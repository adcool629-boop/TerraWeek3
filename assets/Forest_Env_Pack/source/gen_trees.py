#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Top-Down Pixel Trees - Seasons Pack generator
10 trees x 4 seasons x 8 sway frames, 64x64 px each, transparent PNG.
Everything is procedural (no external art). Deterministic: same output on every run.

Usage:  python3 gen_trees.py [output_dir]
"""
import math, random, json, os, sys, zlib, shutil, zipfile
import numpy as np
from PIL import Image, ImageDraw, ImageFont

W = H = 64
NF = 8            # frames per loop
FPS = 8
BASE_Y = 58       # ground contact line (pivot)
BASE_X = 32
SEASONS = ['spring', 'summer', 'autumn', 'winter']
EMPTY, SHADOW, TRUNK, LEAF, BRANCH, SNOWL, OUTL = range(7)
OUTLINED = {TRUNK, LEAF}
BAYER = [[0, 8, 2, 10], [12, 4, 14, 6], [3, 11, 1, 9], [15, 7, 13, 5]]


def bay(x, y):
    return (BAYER[y & 3][x & 3] + 0.5) / 16.0


def clamp(v, a, b):
    return a if v < a else b if v > b else v


def hrand(*args):
    h = 2166136261
    for a in args:
        h ^= (int(a) + 0x9E3779B9) & 0xFFFFFFFF
        h = (h * 16777619) & 0xFFFFFFFF
        h ^= h >> 13
    return (h & 0xFFFF) / 65535.0


def hx(s):
    s = s.lstrip('#')
    return tuple(int(s[i:i + 2], 16) for i in (0, 2, 4))


def pal(*hexes):
    return [hx(h) for h in hexes]


def mix(c1, c2, t):
    return tuple(int(round(c1[i] * (1 - t) + c2[i] * t)) for i in range(3))


def seed_of(name):
    return zlib.crc32(name.encode()) & 0xFFFFFF


# ----------------------------------------------------------------------------
# Palettes  [outline, dark, mid, light, highlight]
# ----------------------------------------------------------------------------
SUMMER = {
    'oak':     pal('#163020', '#245830', '#3a803c', '#60a84a', '#96cd64'),
    'pine':    pal('#0e2c2a', '#18483a', '#246646', '#3e8656', '#68a870'),
    'birch':   pal('#244e2c', '#467d3c', '#6eaa4c', '#9cce60', '#ccec82'),
    'maple':   pal('#18402a', '#1e6434', '#2e8c3c', '#54b44e', '#8cd764'),
    'cherry':  pal('#1e4632', '#2c6440', '#428a50', '#68b062', '#a0d682'),
    'willow':  pal('#285438', '#427648', '#649c5a', '#8ebe70', '#bede96'),
    'cypress': pal('#0e2822', '#164230', '#225c3c', '#387a48', '#5c9c5a'),
    'apple':   pal('#1a4226', '#286632', '#428e3c', '#6ab44a', '#a0d468'),
    'acacia':  pal('#32461e', '#546e28', '#7a9434', '#a4b846', '#ced664'),
    'ginkgo':  pal('#285424', '#467e2c', '#6ea836', '#9ccc48', '#cef068'),
}


def spring_of(p):
    tint = (222, 242, 120)
    return [mix(p[0], tint, 0.10)] + [mix(c, tint, 0.26) for c in p[1:]]


BLOSSOM_PINK = pal('#78305a', '#c4588a', '#ec88b0', '#ffb8d0', '#ffe4ee')
BLOSSOM_WHITE = pal('#6e4a60', '#be8ca4', '#ecc4d2', '#fce4ec', '#fff8fa')
MAPLE_NEW = pal('#3e5c26', '#6a9030', '#9cc040', '#c8e060', '#eaf88c')

AUTUMN = {
    'oak':     [(pal('#46261a', '#78401c', '#a85c24', '#cc822f', '#e8b04c'), 0.45),
                (pal('#523818', '#8a6420', '#bc8e2c', '#dcb446', '#f0d878'), 0.30),
                (pal('#3c3418', '#665a22', '#92822e', '#b8a444', '#d8c870'), 0.25)],
    'pine':    [(pal('#10302a', '#1e4c38', '#2e6a42', '#4c8650', '#7aa468'), 1.0)],
    'birch':   [(pal('#604618', '#a07824', '#d4aa34', '#f0d054', '#fcec8c'), 0.8),
                (pal('#6a5018', '#b08a28', '#e0b83c', '#f6d85c', '#fff0a0'), 0.2)],
    'maple':   [(pal('#54161a', '#8c2220', '#c43828', '#e46030', '#f69648'), 0.5),
                (pal('#5a2810', '#9a4418', '#d06a20', '#ec9430', '#f8c458'), 0.3),
                (pal('#5c4a14', '#a08018', '#d8b424', '#f0d44c', '#faec88'), 0.2)],
    'cherry':  [(pal('#58222a', '#963434', '#c85438', '#e47c48', '#f6ac68'), 0.6),
                (pal('#6a3a30', '#a8583c', '#d88a4c', '#eeb468', '#f8d894'), 0.4)],
    'willow':  [(pal('#585428', '#8c8438', '#b8ac4c', '#d8cc6c', '#eee696'), 1.0)],
    'cypress': [(pal('#1e3222', '#32502a', '#4c6c32', '#6c8a40', '#94a85c'), 1.0)],
    'apple':   [(pal('#504218', '#866c24', '#b4942e', '#d6b84a', '#f0dc78'), 0.6),
                (pal('#3c5a24', '#58802c', '#7ea440', '#a4c458', '#c8e080'), 0.4)],
    'acacia':  [(pal('#5a461c', '#8c6c28', '#b8923a', '#d8b858', '#eed888'), 1.0)],
    'ginkgo':  [(pal('#784e0c', '#bc8412', '#e8b820', '#fcdc44', '#fff284'), 1.0)],
}

TRUNKS = {
    'oak':     pal('#2a1a12', '#46301e', '#684628', '#8a6236', '#aa8450'),
    'pine':    pal('#341c14', '#583020', '#80482c', '#a46a3c', '#c4904e'),
    'birch':   pal('#32323c', '#8c8c96', '#c4c4c8', '#e6e6e4', '#ffffff'),
    'maple':   pal('#301e16', '#52362a', '#7a5440', '#a07858', '#c4a07c'),
    'cherry':  pal('#2a1c20', '#4a3036', '#6e4a50', '#92686c', '#b88c8c'),
    'willow':  pal('#2c2418', '#4a3c28', '#6c5a3c', '#8e7a52', '#b09c6c'),
    'cypress': pal('#2e1c14', '#4a2e1e', '#6e482a', '#946438', '#b88a52'),
    'apple':   pal('#2e2016', '#4e3622', '#76502c', '#9c7040', '#c09860'),
    'acacia':  pal('#2c1e18', '#523a2a', '#7c5a3c', '#a47c52', '#caa070'),
    'ginkgo':  pal('#30261c', '#54443a', '#7c6850', '#a28c6c', '#c6b090'),
}

SNOW_PAL = pal('#506a90', '#a8bddc', '#d4e2f2', '#f0f6fc', '#ffffff')
SNOW_OUT = hx('#5a7498')
SHADOW_COL = hx('#121a28')
PATS = [[(0, 0), (1, 0), (1, 1)], [(0, 0), (1, 0), (2, 0), (1, 1)], [(0, 0), (0, 1), (1, 1)], [(0, 0), (1, 0)]]
PAT_COL = [(0, 0), (0, 1), (0, 2)]
PAT_FAN = [(-2, 0), (-1, -1), (0, -1), (1, -1), (2, 0)]


# ----------------------------------------------------------------------------
# Canvas
# ----------------------------------------------------------------------------
class Canvas:
    def __init__(s):
        s.rgb = np.zeros((H, W, 3), np.uint8)
        s.a = np.zeros((H, W), np.uint8)
        s.layer = np.zeros((H, W), np.uint8)
        s.ocol = np.zeros((H, W, 3), np.uint8)

    def put(s, x, y, col, layer, ocol=None, alpha=255):
        if 0 <= x < W and 0 <= y < H:
            s.rgb[y, x] = col
            s.a[y, x] = alpha
            s.layer[y, x] = layer
            if ocol is not None:
                s.ocol[y, x] = ocol

    def free(s, x, y):
        return 0 <= x < W and 0 <= y < H and s.layer[y, x] in (EMPTY, SHADOW)

    def outline(s):
        new = []
        for y in range(H):
            for x in range(W):
                if s.layer[y, x] in (EMPTY, SHADOW):
                    cands = []
                    for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                        xx, yy = x + dx, y + dy
                        if 0 <= xx < W and 0 <= yy < H and s.layer[yy, xx] in OUTLINED:
                            cands.append(tuple(int(v) for v in s.ocol[yy, xx]))
                    if cands:
                        new.append((x, y, min(cands, key=sum)))
        for x, y, c in new:
            s.rgb[y, x] = c
            s.a[y, x] = 255
            s.layer[y, x] = OUTL

    def image(s):
        arr = np.dstack([s.rgb, s.a])
        return Image.fromarray(arr, 'RGBA')


# ----------------------------------------------------------------------------
# Foliage primitives
# ----------------------------------------------------------------------------
class Blob:
    """Round-ish leaf cluster (kind: round | column)."""

    def __init__(s, cx, cy, rx, ry, p, seed, snow=0.0, kind='round', dots=None,
                 speck_n=None, fan=False):
        s.cx, s.cy, s.rx, s.ry, s.pal, s.seed, s.snow, s.kind = cx, cy, rx, ry, p, seed, snow, kind
        r = random.Random(seed)
        s.k = r.choice([5, 6, 7, 8])
        s.sa = r.uniform(0.06, 0.11)
        s.sp = r.uniform(0, 6.28)
        n = speck_n if speck_n is not None else max(4, int(rx * ry / 9))
        s.specks = []
        for _ in range(n):
            a = r.uniform(0, 6.28)
            rr = math.sqrt(r.uniform(0.02, 0.82))
            px = cx + math.cos(a) * rr * rx
            py = cy + math.sin(a) * rr * ry
            side = (px - cx) / rx * 0.55 + (py - cy) / ry * 0.8
            delta = 1 if side < 0.05 else -1
            if r.random() < 0.22:
                delta = -delta
            if kind == 'column':
                pat = PAT_COL
            elif fan and r.random() < 0.55:
                pat = PAT_FAN
                delta = 1 if r.random() < 0.7 else -1
            else:
                pat = r.choice(PATS)
            s.specks.append((int(px), int(py), pat, delta, r.random() < 0.18, r.randrange(NF)))
        s.dots = []
        if dots:
            for _ in range(dots['n'] if isinstance(dots['n'], int) else (1 if r.random() < dots['n'] else 0)):
                a = r.uniform(0, 6.28)
                rr = math.sqrt(r.uniform(0.05, 0.6))
                s.dots.append((int(cx + math.cos(a) * rr * rx), int(cy + math.sin(a) * rr * ry), dots))


def draw_blob(S, b, ox, oy, t):
    cells = {}
    cx, cy = b.cx + ox, b.cy + oy
    rx, ry = b.rx, b.ry
    snow_cells = set()
    for y in range(int(cy - ry - 3), int(cy + ry + 4)):
        for x in range(int(cx - rx - 3), int(cx + rx + 4)):
            if not (0 <= x < W and 0 <= y < H):
                continue
            nx = (x + 0.5 - cx) / rx
            ny = (y + 0.5 - cy) / ry
            d = math.hypot(nx, ny)
            ang = math.atan2(ny, nx)
            edge = 1 + b.sa * math.sin(b.k * ang + b.sp) + 0.05 * math.sin(9 * ang + b.sp * 2)
            if d > edge:
                continue
            lx, ly = x - ox, y - oy
            light = nx * 0.55 + ny * 0.80
            v = 0.60 - 0.36 * light
            v += 0.10 * clamp((46 - b.cy) / 46.0 - 0.3, -0.3, 0.5)
            v += (bay(lx, ly) - 0.5) * 0.17
            if b.kind == 'column':
                v += (hrand(lx, ly // 3, b.seed) - 0.5) * 0.30
            rim = d / edge
            if rim > 0.80:
                if light > 0.12:
                    v -= 0.22
                elif light < -0.3:
                    v += 0.12
            idx = 1 if v < 0.27 else 2 if v < 0.50 else 3 if v < 0.74 else 4
            if rim > 0.86 and light > 0.30:
                idx = 1
            cells[(x, y)] = idx
            if b.snow > 0:
                s_val = -ny + 0.55 * (hrand(lx, ly, b.seed + 7) - 0.5) - 0.15 * nx
                if s_val > 0.85 - 1.55 * b.snow:
                    snow_cells.add((x, y))
    for (px, py, pat, delta, flut, ph) in b.specks:
        if flut and ((t + ph) % 4) < 2:
            dl = 0
        else:
            dl = delta
        for (qx, qy) in pat:
            x, y = px + ox + qx, py + oy + qy
            if (x, y) in cells:
                cells[(x, y)] = int(clamp(cells[(x, y)] + dl, 1, 4))
    for (x, y), idx in cells.items():
        if (x, y) in snow_cells:
            S.put(x, y, SNOW_PAL[idx], LEAF, SNOW_OUT)
        else:
            S.put(x, y, b.pal[idx], LEAF, b.pal[0])
    for (dx, dy, dd) in b.dots:
        x, y = dx + ox, dy + oy
        if (x, y) not in cells or (x, y) in snow_cells:
            continue
        c = dd['cols']
        if dd['kind'] == 'fruit':
            for (qx, qy, ci) in ((0, 0, 2), (1, 0, 1), (0, 1, 1), (1, 1, 0)):
                if (x + qx, y + qy) in cells:
                    S.put(x + qx, y + qy, c[ci], LEAF, b.pal[0])
        else:
            for (qx, qy, ci) in ((0, 0, 1), (1, 0, 0)):
                if (x + qx, y + qy) in cells:
                    S.put(x + qx, y + qy, c[ci], LEAF, b.pal[0])


class Tier:
    """Triangular conifer tier."""

    def __init__(s, cx, top, hw, h, p, seed, snow=0.0):
        s.cx, s.top, s.hw, s.h, s.pal, s.seed, s.snow = cx, top, hw, h, p, seed, snow
        r = random.Random(seed)
        s.specks = []
        for _ in range(int(hw * h / 9)):
            yy = r.uniform(0.2, 0.85)
            half = hw * yy
            xx = r.uniform(-half * 0.85, half * 0.85)
            s.specks.append((int(cx + xx), int(top + yy * h), r.choice([[(0, 0), (1, 0), (2, 0)], [(0, 0), (1, 0)], [(0, 0), (1, 1)]]),
                             1 if xx < 0 else -1, r.random() < 0.2, r.randrange(NF)))


def draw_tier(S, tr, ox, oy, t):
    cells = {}
    snow_cells = set()
    cx, top, hw, h = tr.cx + ox, tr.top + oy, tr.hw, tr.h
    for y in range(top, top + h + 4):
        ny = (y - top) / float(h)
        half = hw * min(1.0, (y - top + 0.7) / float(h)) ** 0.92
        half += (hrand(y - oy, tr.seed) - 0.5) * 2.4
        for x in range(int(cx - hw - 3), int(cx + hw + 4)):
            if not (0 <= x < W and 0 <= y < H):
                continue
            dx = x + 0.5 - cx
            if abs(dx) > half:
                continue
            tooth = abs(((x - cx + 100) % 7) - 3.5)
            bottom = top + h - 2.0 + (3.5 - tooth) * 0.75
            if y > bottom:
                continue
            lx, ly = x - ox, y - oy
            v = 0.60 - 0.34 * (dx / max(1.0, hw)) - 0.10 * ny
            if (y - top) % 4 == 3:
                v -= 0.16
            if y > bottom - 1.6:
                v -= 0.22
            v += (bay(lx, ly) - 0.5) * 0.16
            idx = 1 if v < 0.27 else 2 if v < 0.50 else 3 if v < 0.74 else 4
            cells[(x, y)] = idx
            if tr.snow > 0:
                if ny < tr.snow * 0.78 + 0.28 * (hrand(lx, ly, tr.seed + 3) - 0.5) - 0.10 * (dx / max(1.0, hw)) \
                        and y < bottom - 1.2:
                    snow_cells.add((x, y))
    for (px, py, pat, delta, flut, ph) in tr.specks:
        dl = 0 if (flut and ((t + ph) % 4) < 2) else delta
        for (qx, qy) in pat:
            x, y = px + ox + qx, py + oy + qy
            if (x, y) in cells:
                cells[(x, y)] = int(clamp(cells[(x, y)] + dl, 1, 4))
    for (x, y), idx in cells.items():
        if (x, y) in snow_cells:
            S.put(x, y, SNOW_PAL[idx], LEAF, SNOW_OUT)
        else:
            S.put(x, y, tr.pal[idx], LEAF, tr.pal[0])


# ----------------------------------------------------------------------------
# Trunk, branches, ground
# ----------------------------------------------------------------------------
def trunk_x(tr, t):
    return BASE_X + tr['lean'] * (t ** 1.5) + tr.get('wob', 0) * math.sin(t * 5.5)


def draw_trunk(S, tr, name):
    p = tr['pal']
    seed = seed_of(name)
    fy = tr['fork_y']
    for y in range(fy, BASE_Y + 1):
        t = (BASE_Y - y) / float(max(1, BASE_Y - fy))
        cxp = trunk_x(tr, t)
        w = tr['w_base'] * (1 - t) + tr['w_top'] * t
        flare = max(0, y - (BASE_Y - 5)) * (0.35 if tr.get('birch') else 0.8)
        half = w / 2.0 + flare
        left = int(round(cxp - half))
        right = int(round(cxp + half))
        n = max(2, right - left)
        for x in range(left, right):
            u = (x - left + 0.5) / n
            if tr.get('birch'):
                idx = 4 if u < 0.3 else 3 if u < 0.65 else 2
                col = p[idx]
                wmark = 2 + int(hrand(y, seed, 1) * max(1, n - 1))
                st = left + int(hrand(y, seed, 2) * max(1, n - wmark + 1))
                if hrand(y, seed) > 0.84 and st <= x < st + wmark:
                    col = hx('#2a2a30')
                if y >= BASE_Y - 1:
                    col = mix(col, hx('#3a3a44'), 0.30)
            else:
                idx = 3 if u < 0.22 else 2 if u < 0.62 else 1
                if x == left and n >= 6:
                    idx = 4
                g = hrand(x, y // 3, seed)
                if g > 0.80 and idx < 4:
                    idx = max(1, idx - 1)
                elif g < 0.07 and idx >= 2:
                    idx = min(4, idx + 1)
                if (x - left) == int(n * 0.45) and hrand(y // 2, seed) > 0.4:
                    idx = max(1, idx - 1)
                if y >= BASE_Y - 1:
                    idx = max(1, idx - 1)
                col = p[idx]
            S.put(x, y, col, TRUNK, p[0])


class Skeleton:
    def __init__(s, fx, fy, n_main, spread, L0, depth_max, seed, shrink=(0.62, 0.80)):
        r = random.Random(seed)
        s.nodes = [(fx, fy, 0.0, 0.0)]
        s.segs = []

        def grow(ni, x, y, ang, L, depth, dist):
            ang = clamp(ang, -math.pi + 0.3, -0.3)
            x2 = x + math.cos(ang) * L
            y2 = y + math.sin(ang) * L
            d2 = dist + L
            s.nodes.append((x2, y2, d2, r.uniform(-0.5, 0.5) + 0.05 * x2))
            nj = len(s.nodes) - 1
            s.segs.append((ni, nj, depth))
            if depth < depth_max:
                nc = 2 if depth < depth_max - 1 else r.choice([1, 2])
                for k in range(nc):
                    a = ang + (k - (nc - 1) / 2.0) * r.uniform(0.7, 1.1) + r.uniform(-0.2, 0.2)
                    grow(nj, x2, y2, a, L * r.uniform(*shrink), depth + 1, d2)

        for k in range(n_main):
            a = -math.pi / 2 + (k - (n_main - 1) / 2.0) * spread / max(1, n_main - 1) + r.uniform(-0.12, 0.12)
            grow(0, fx, fy, a, L0 * r.uniform(0.85, 1.1), 0, 0.0)


def line_pts(x0, y0, x1, y1):
    pts = []
    dx, dy = abs(x1 - x0), abs(y1 - y0)
    sx = 1 if x0 < x1 else -1
    sy = 1 if y0 < y1 else -1
    err = dx - dy
    while True:
        pts.append((x0, y0))
        if x0 == x1 and y0 == y1:
            break
        e2 = 2 * err
        if e2 > -dy:
            err -= dy
            x0 += sx
        if e2 < dx:
            err += dx
            y0 += sy
    return pts


def draw_skeleton(S, sk, t, A, tp, snow, name, max_depth=99):
    seed = seed_of(name)
    pts = []
    for (x, y, dist, ph0) in sk.nodes:
        w = min(1.0, dist / 18.0)
        ph = 2 * math.pi * t / NF + ph0
        pts.append((x + A * w * math.sin(ph), y + 0.5 * A * w * math.sin(ph + 0.9)))
    order = sorted([sg for sg in sk.segs if sg[2] <= max_depth], key=lambda sg: sg[2])
    for (a, b, depth) in order:
        x0, y0 = int(round(pts[a][0])), int(round(pts[a][1]))
        x1, y1 = int(round(pts[b][0])), int(round(pts[b][1]))
        for (x, y) in line_pts(x0, y0, x1, y1):
            if depth == 0:
                S.put(x - 1, y, tp[3], TRUNK, tp[0])
                S.put(x, y, tp[2], TRUNK, tp[0])
                S.put(x + 1, y, tp[1], TRUNK, tp[0])
            elif depth == 1:
                S.put(x, y, tp[2], TRUNK, tp[0])
                S.put(x + 1, y, tp[1], TRUNK, tp[0])
            else:
                S.put(x, y, tp[2] if depth == 2 else tp[1], BRANCH)
    if snow:
        for (a, b, depth) in order:
            if depth > 2:
                continue
            x0, y0 = int(round(pts[a][0])), int(round(pts[a][1]))
            x1, y1 = int(round(pts[b][0])), int(round(pts[b][1]))
            if abs(x1 - x0) < abs(y1 - y0) * 0.6 and depth > 0:
                continue
            for (x, y) in line_pts(x0, y0, x1, y1):
                if hrand(x - int(A * 0), y, seed + depth) < 0.55:
                    yy = y - 1 - (1 if depth == 0 else 0)
                    if S.free(x, yy):
                        S.put(x, yy, hx('#f4f8fc') if hrand(x, y, 5) > 0.3 else hx('#d4e2f2'), SNOWL)
    return pts


def draw_node_strands(S, pts, sk, t, A):
    tips = [b for (a, b, d) in sk.segs if d >= 1]
    for i, b in enumerate(tips):
        x, y = int(round(pts[b][0])), int(round(pts[b][1]))
        ln = min(9 + int(hrand(i, 3) * 8), 55 - y)
        for row in range(max(0, ln)):
            rr = row / float(max(1, ln))
            dx = int(round(A * 1.5 * rr * math.sin(2 * math.pi * t / NF - 0.30 * row + 0.05 * x)))
            S.put(x + dx, y + 1 + row, hx('#8c7a4c') if (row % 3) else hx('#b09c6c'), BRANCH)


def draw_shadow(S):
    cx, cy, rx, ry = 34.5, 55.5, 19.5, 5.6
    for y in range(int(cy - ry - 1), int(cy + ry + 2)):
        for x in range(int(cx - rx - 1), int(cx + rx + 2)):
            d = ((x + 0.5 - cx) / rx) ** 2 + ((y + 0.5 - cy) / ry) ** 2
            if d <= 1:
                if d > 0.78 and bay(x, y) < 0.5:
                    continue
                S.put(x, y, SHADOW_COL, SHADOW, alpha=104 if d < 0.5 else 64)


def draw_snow_ground(S):
    cx, cy, rx, ry = 33.0, 55.8, 21.0, 5.6
    for y in range(int(cy - ry - 1), int(cy + ry + 2)):
        for x in range(int(cx - rx - 1), int(cx + rx + 2)):
            ang = math.atan2(y + 0.5 - cy, x + 0.5 - cx)
            edge = 1 + 0.07 * math.sin(5 * ang + 1.1) + 0.05 * math.sin(11 * ang)
            d = math.hypot((x + 0.5 - cx) / rx, (y + 0.5 - cy) / ry)
            if d <= edge:
                lit = ((x + 0.5 - cx) / rx) * 0.5 + ((y + 0.5 - cy) / ry) * 0.7
                if lit > 0.35:
                    col = hx('#aebfdc')
                elif lit > -0.1:
                    col = hx('#d0ddf0')
                else:
                    col = hx('#eaf2fa')
                if d > edge - 0.12 and bay(x, y) < 0.45:
                    col = mix(col, hx('#8ea4c8'), 0.5)
                S.put(x, y, col, SHADOW)


def draw_snow_mound(S):
    cx, cy, rx, ry = 32.5, 57.2, 9.0, 2.7
    for y in range(int(cy - ry - 1), int(cy + ry + 2)):
        for x in range(int(cx - rx - 1), int(cx + rx + 2)):
            d = math.hypot((x + 0.5 - cx) / rx, (y + 0.5 - cy) / ry)
            if d <= 1 + 0.12 * math.sin(x * 1.7):
                lit = (x + 0.5 - cx) / rx * 0.5 + (y + 0.5 - cy) / ry * 0.7
                col = hx('#ffffff') if lit < -0.25 else hx('#e4eef8') if lit < 0.25 else hx('#bccde6')
                S.put(x, y, col, SNOWL)


def draw_ground_decals(S, name, season, cfg):
    r = random.Random(seed_of(name + season))
    if season == 'autumn':
        pl = cfg['seasons']['autumn']['pals']
        for _ in range(15):
            a = r.uniform(0, 6.28)
            rr = math.sqrt(r.uniform(0.15, 1.0))
            x = int(33 + math.cos(a) * rr * 19)
            y = int(56 + math.sin(a) * rr * 4.5)
            if abs(x - 32) < 3:
                continue
            p = r.choices([q for q, w in pl], [w for q, w in pl])[0]
            c = p[r.choice([1, 2, 2, 3])]
            S.put(x, y, c, BRANCH)
            if r.random() < 0.6:
                S.put(x + 1, y, p[2], BRANCH)
    elif season == 'spring':
        cols = {'cherry': ['#ffb8d0', '#ffe4ee', '#ec88b0'], 'apple': ['#fce4ec', '#ffffff', '#ecc4d2']}.get(
            name, ['#ffffff', '#f6d23c', '#fff0a0'])
        for _ in range(11):
            a = r.uniform(0, 6.28)
            rr = math.sqrt(r.uniform(0.1, 1.0))
            x = int(33 + math.cos(a) * rr * 19)
            y = int(56 + math.sin(a) * rr * 4.5)
            if abs(x - 32) < 3:
                continue
            S.put(x, y, hx(r.choice(cols)), BRANCH)


# ----------------------------------------------------------------------------
# Species definitions
# ----------------------------------------------------------------------------
def season_pals(name, season):
    if season == 'summer':
        return [(SUMMER[name], 1.0)]
    if season == 'spring':
        if name == 'cherry':
            return [(BLOSSOM_PINK, 0.86), (spring_of(SUMMER['cherry']), 0.14)]
        if name == 'apple':
            return [(BLOSSOM_WHITE, 0.72), (spring_of(SUMMER['apple']), 0.28)]
        if name == 'maple':
            return [(spring_of(SUMMER['maple']), 0.7), (MAPLE_NEW, 0.3)]
        return [(spring_of(SUMMER[name]), 1.0)]
    if season == 'autumn':
        return AUTUMN[name]
    return [(SUMMER[name], 1.0)]


ROUND = {
    'oak': [(32, 12, 11, 9), (20, 17, 10, 9), (44, 17, 10, 9), (14, 28, 9, 8), (50, 28, 9, 8), (22, 32, 11, 9),
            (42, 32, 11, 9), (32, 24, 13, 11), (32, 37, 12, 7), (18, 39, 8, 6), (46, 39, 8, 6)],
    'birch': [(32, 9, 7, 6), (24, 15, 7, 6), (40, 15, 7, 6), (32, 18, 8, 7), (20, 24, 7, 6), (44, 24, 7, 6),
              (29, 27, 8, 6), (37, 29, 8, 6), (24, 33, 6, 5), (41, 34, 6, 5), (32, 36, 7, 5), (17, 30, 5, 4),
              (47, 30, 5, 4)],
    'maple': [(32, 9, 8, 7), (23, 14, 8, 7), (41, 14, 8, 7), (16, 22, 8, 7), (48, 22, 8, 7), (32, 20, 11, 9),
              (22, 28, 9, 8), (42, 28, 9, 8), (14, 34, 6, 5), (50, 34, 6, 5), (28, 37, 9, 6), (38, 38, 9, 6),
              (32, 30, 10, 8)],
    'cherry': [(32, 14, 10, 8), (18, 19, 10, 8), (46, 19, 10, 8), (10, 29, 8, 7), (54, 29, 8, 7), (24, 27, 11, 9),
               (40, 27, 11, 9), (32, 22, 11, 9), (32, 36, 11, 7), (17, 36, 7, 5), (47, 36, 7, 5)],
    'willow': [(32, 13, 12, 8), (18, 19, 12, 8), (46, 19, 12, 8), (10, 26, 8, 7), (54, 26, 8, 7), (26, 22, 13, 9),
               (38, 22, 13, 9), (32, 28, 14, 8)],
    'apple': [(32, 16, 10, 9), (22, 22, 9, 8), (42, 22, 9, 8), (15, 31, 7, 6), (49, 31, 7, 6), (26, 33, 9, 7),
              (38, 33, 9, 7), (32, 26, 11, 9), (32, 39, 9, 5)],
    'acacia': [(32, 14, 12, 6), (18, 18, 11, 6), (46, 18, 11, 6), (8, 22, 7, 5), (56, 22, 7, 5), (26, 11, 10, 5),
               (40, 11, 10, 5), (32, 21, 14, 5), (14, 24, 8, 4), (50, 24, 8, 4)],
    'ginkgo': [(32, 9, 7, 7), (24, 17, 9, 8), (40, 17, 9, 8), (18, 27, 10, 8), (46, 27, 10, 8), (30, 25, 11, 9),
               (35, 34, 11, 8), (14, 37, 7, 5), (50, 37, 7, 5), (24, 39, 8, 5), (42, 40, 8, 5)],
}
CYPRESS = [(32, 10, 5, 7), (32, 17, 7, 8), (31, 25, 8, 9), (33, 33, 8, 9), (32, 41, 8, 9), (32, 48, 7, 6),
           (26, 31, 5, 8), (38, 30, 5, 8), (27, 42, 5, 7), (37, 41, 5, 7)]
PINE_TIERS = [(32, 2, 9, 14), (32, 11, 13, 15), (32, 21, 17, 16), (32, 32, 21, 17)]

TRUNK_CFG = {
    'oak':     dict(w_base=10, w_top=7, fork_y=32, lean=0, wob=0.8),
    'pine':    dict(w_base=6, w_top=5, fork_y=46, lean=0),
    'birch':   dict(w_base=5, w_top=4, fork_y=20, lean=1.5, wob=0.8, birch=True),
    'maple':   dict(w_base=8, w_top=6, fork_y=30, lean=0, wob=0.6),
    'cherry':  dict(w_base=7, w_top=5, fork_y=28, lean=-3, wob=1.2),
    'willow':  dict(w_base=9, w_top=6, fork_y=30, lean=2, wob=0.8),
    'cypress': dict(w_base=5, w_top=4, fork_y=46, lean=0),
    'apple':   dict(w_base=7, w_top=5, fork_y=34, lean=1, wob=1.0),
    'acacia':  dict(w_base=6, w_top=4, fork_y=26, lean=-2, wob=1.5),
    'ginkgo':  dict(w_base=7, w_top=5, fork_y=30, lean=0, wob=0.5),
}
SKEL_CFG = {  # n_main, spread, L0, depth
    'oak': (4, 2.6, 13, 3), 'birch': (3, 1.5, 10, 3), 'maple': (4, 2.4, 12, 3), 'cherry': (4, 2.8, 12, 3),
    'willow': (3, 2.4, 10, 2), 'apple': (3, 2.2, 10, 3), 'acacia': (3, 1.9, 12, 2), 'ginkgo': (3, 1.4, 11, 3),
}
SWAY = {'oak': 1.3, 'pine': 1.1, 'birch': 1.7, 'maple': 1.3, 'cherry': 1.4, 'willow': 1.5, 'cypress': 1.0,
        'apple': 1.2, 'acacia': 1.2, 'ginkgo': 1.5}
SHOW_BRANCHES = {'birch', 'acacia', 'cherry', 'ginkgo'}
EVERGREEN = {'pine', 'cypress'}
NAMES = ['oak', 'pine', 'birch', 'maple', 'cherry', 'willow', 'cypress', 'apple', 'acacia', 'ginkgo']

FRUIT_RED = [hx('#8c1c1c'), hx('#d03030'), hx('#ff8a78')]
FRUIT_YEL = [hx('#a07818'), hx('#e0b030'), hx('#fff0a0')]
FL_PINK = [hx('#ff9cc0'), hx('#ffe6f0')]
FL_YEL = [hx('#f6d23c'), hx('#fff0a0')]


def dots_for(name, season):
    if name == 'apple':
        if season == 'summer':
            return dict(kind='fruit', cols=FRUIT_RED, n=0.75)
        if season == 'autumn':
            return dict(kind='fruit', cols=FRUIT_RED, n=1)
        if season == 'spring':
            return dict(kind='flower', cols=FL_PINK, n=2)
    if name == 'cherry' and season == 'spring':
        return dict(kind='flower', cols=[hx('#ffffff'), hx('#ffe4ee')], n=2)
    if name == 'acacia' and season == 'spring':
        return dict(kind='flower', cols=FL_YEL, n=2)
    return None


def build_foliage(name, season):
    """Returns list of drawables (Blob / Tier) + willow strands config."""
    items = []
    seed0 = seed_of(name + season)
    r = random.Random(seed0)
    pl = season_pals(name, season)
    snow_amt = 0.0
    bare = (season == 'winter' and name not in EVERGREEN)
    if season == 'winter' and name in EVERGREEN:
        snow_amt = 0.38 if name == 'cypress' else 0.60
    if bare:
        # sparse dead leaves for oak only
        if name == 'oak':
            for i, (cx, cy, rx, ry) in enumerate(ROUND['oak']):
                if i % 4 == 1:
                    p = pal('#3a261a', '#5a3a20', '#7e5428', '#a07434', '#c0964c')
                    items.append(Blob(cx + (4 if cx < 32 else -4 if cx > 32 else 0), cy + 3, 3, 2, p, seed0 + i, snow=0.5,
                                      speck_n=2))
        return items, True
    pick = lambda: r.choices([q for q, w in pl], [w for q, w in pl])[0]
    dots = dots_for(name, season)
    if name == 'pine':
        for i, (cx, top, hw, h) in enumerate(PINE_TIERS):
            items.append(Tier(cx, top, hw, h, pick(), seed0 + i, snow=snow_amt))
    elif name == 'cypress':
        for i, (cx, cy, rx, ry) in enumerate(CYPRESS):
            items.append(Blob(cx, cy, rx, ry, pick(), seed0 + i, snow=snow_amt, kind='column'))
    else:
        for i, (cx, cy, rx, ry) in enumerate(ROUND[name]):
            items.append(Blob(cx, cy, rx, ry, pick(), seed0 + i, dots=dots, fan=(name == 'ginkgo')))
    return items, False


# strands for willow: (x, start_y, length, lit, double)
def build_willow_strands(season):
    r = random.Random(seed_of('willowstrands' + season))
    out = []
    xs = list(range(7, 58, 2))
    for x in xs:
        if abs(x - 32) < 5:
            continue
        sy = int(26 + 12 * math.sqrt(max(0.0, 1 - ((x - 32) / 26.0) ** 2)) - 4)
        ln = r.randint(12, 22)
        ln = min(ln, 56 - sy)
        out.append((x, sy, ln, r.random() < 0.5, r.random() < 0.6, r.uniform(0, 6.28)))
    return out


def draw_strands(S, strands, t, A, p, thin_col=None, sparse=False):
    for (x0, sy, ln, lit, dbl, ph0) in strands:
        if sparse and int(x0 / 2) % 3 != 0:
            continue
        for row in range(ln):
            rr = row / float(ln)
            dx = int(round(A * 1.6 * rr * math.sin(2 * math.pi * t / NF - 0.30 * row + ph0 * 0.5 + 0.05 * x0)))
            x = x0 + dx
            y = sy + row
            if thin_col is not None:
                S.put(x, y, thin_col[0] if (row % 3) else thin_col[1], BRANCH)
                continue
            idx = (4 if row < 2 else 3) if lit else 2
            if row % 4 == 3:
                idx -= 1
            if row > ln - 3:
                idx = max(1, idx - 1)
            S.put(x, y, p[idx], BRANCH)
            if dbl:
                S.put(x + 1, y, p[max(1, idx - 1)], BRANCH)


def sway(t, cx, cy, A):
    w = clamp((BASE_Y - cy) / 46.0, 0.30, 1.0)
    ph = 2 * math.pi * t / NF + 0.05 * cx + 0.035 * cy
    ox = int(round(A * w * math.sin(ph)))
    oy = int(round(0.60 * A * w * math.sin(2 * ph + 0.7)))
    return ox, oy


FOLIAGE = {}
SKELS = {}


def get_foliage(name, season):
    k = (name, season)
    if k not in FOLIAGE:
        FOLIAGE[k] = build_foliage(name, season)
    return FOLIAGE[k]


def get_skel(name):
    if name not in SKELS and name in SKEL_CFG:
        tr = TRUNK_CFG[name]
        fx = trunk_x(tr, 1.0)
        n, sp, L0, dm = SKEL_CFG[name]
        SKELS[name] = Skeleton(fx, tr['fork_y'], n, sp, L0, dm, seed_of(name + 'skel'))
    return SKELS.get(name)


def render(name, season, t):
    S = Canvas()
    A = SWAY[name]
    tr = dict(TRUNK_CFG[name])
    tr['pal'] = TRUNKS[name]
    cfg = dict(seasons={s: dict(pals=season_pals(name, s)) for s in SEASONS})
    if season == 'winter':
        draw_snow_ground(S)
    else:
        draw_shadow(S)
    draw_ground_decals(S, name, season, cfg)
    draw_trunk(S, tr, name)
    if season == 'winter':
        draw_snow_mound(S)
    items, bare = get_foliage(name, season)
    sk = get_skel(name)
    if sk is not None and (bare or name in SHOW_BRANCHES):
        pts = draw_skeleton(S, sk, t, A, TRUNKS[name], snow=(bare and season == 'winter'), name=name,
                            max_depth=(99 if bare else 0))
        if name == 'willow' and bare:
            draw_node_strands(S, pts, sk, t, A)
    # order: upper first, lower in front
    def key(it):
        return (it.cy, it.cx) if isinstance(it, Blob) else (it.top, it.cx)
    for it in sorted(items, key=key):
        if isinstance(it, Blob):
            ox, oy = sway(t, it.cx, it.cy, A)
            draw_blob(S, it, ox, oy, t)
        else:
            ox, oy = sway(t, it.cx, it.top + it.h * 0.4, A)
            draw_tier(S, it, ox, oy, t)
    if name == 'willow' and season != 'winter':
        strands = build_willow_strands(season)
        if season != 'winter':
            draw_strands(S, strands, t, A, items[0].pal if items else SUMMER['willow'])
    S.outline()
    return S.image()


# ----------------------------------------------------------------------------
# Packaging
# ----------------------------------------------------------------------------
BG = {'spring': hx('#86b85c'), 'summer': hx('#68a048'), 'autumn': hx('#a09444'), 'winter': hx('#dce8f2')}


def bg_tile(season, w, h):
    base = BG[season]
    arr = np.zeros((h, w, 3), np.uint8)
    for y in range(h):
        for x in range(w):
            g = hrand(x // 2, y // 2, 99)
            c = mix(base, (255, 255, 255), 0.06) if g > 0.88 else mix(base, (0, 0, 0), 0.07) if g < 0.10 else base
            arr[y, x] = c
    return Image.fromarray(arr, 'RGB').convert('RGBA')


def build(out):
    for d in ['atlas', 'sheets', 'frames', 'static', 'preview', 'palette', 'source']:
        os.makedirs(os.path.join(out, d), exist_ok=True)
    all_frames = {}
    for name in NAMES:
        for season in SEASONS:
            all_frames[(name, season)] = [render(name, season, t) for t in range(NF)]
            print('rendered', name, season, flush=True)

    # sheets, frames, static
    atlas = Image.new('RGBA', (NF * W, len(NAMES) * len(SEASONS) * H), (0, 0, 0, 0))
    meta_frames, anims = {}, {}
    row = 0
    for name in NAMES:
        for season in SEASONS:
            fr = all_frames[(name, season)]
            strip = Image.new('RGBA', (NF * W, H), (0, 0, 0, 0))
            fdir = os.path.join(out, 'frames', name, season)
            os.makedirs(fdir, exist_ok=True)
            keys = []
            for i, im in enumerate(fr):
                strip.paste(im, (i * W, 0))
                atlas.paste(im, (i * W, row * H))
                im.save(os.path.join(fdir, '%s_%s_%d.png' % (name, season, i)))
                key = '%s_%s_%d' % (name, season, i)
                keys.append(key)
                meta_frames[key] = {'frame': {'x': i * W, 'y': row * H, 'w': W, 'h': H},
                                    'sourceSize': {'w': W, 'h': H},
                                    'pivot': {'x': BASE_X / float(W), 'y': BASE_Y / float(H)}}
            strip.save(os.path.join(out, 'sheets', '%s_%s.png' % (name, season)))
            fr[0].save(os.path.join(out, 'static', '%s_%s.png' % (name, season)))
            anims['%s_%s' % (name, season)] = keys
            row += 1
    atlas.save(os.path.join(out, 'atlas', 'trees_atlas.png'))
    meta = {'meta': {'app': 'gen_trees.py', 'image': 'trees_atlas.png', 'format': 'RGBA8888',
                     'size': {'w': atlas.width, 'h': atlas.height}, 'frame_size': W,
                     'frames_per_animation': NF, 'fps': FPS, 'loop': True,
                     'pivot_note': 'pivot = ground contact point (x=0.5, y=%.4f)' % (BASE_Y / float(H)),
                     'trees': NAMES, 'seasons': SEASONS},
            'frames': meta_frames, 'animations': anims}
    with open(os.path.join(out, 'atlas', 'trees_atlas.json'), 'w') as f:
        json.dump(meta, f, indent=1)

    # previews
    try:
        font = ImageFont.load_default()
    except Exception:
        font = None
    sc = 3
    for part, names in (('1', NAMES[:5]), ('2', NAMES[5:])):
        cw = W * sc
        im = Image.new('RGBA', (cw * 4, cw * len(names) + 0), (0, 0, 0, 255))
        for ri, name in enumerate(names):
            for ci, season in enumerate(SEASONS):
                tile = bg_tile(season, W, H)
                tile.alpha_composite(all_frames[(name, season)][0])
                tile = tile.resize((cw, cw), Image.NEAREST)
                im.paste(tile, (ci * cw, ri * cw))
                d = ImageDraw.Draw(im)
                d.text((ci * cw + 4, ri * cw + 3), '%s / %s' % (name, season), fill=(20, 20, 20, 255), font=font)
        im.convert('RGB').save(os.path.join(out, 'preview', 'overview_%s.png' % part))
    # sway GIF (all 40, 2x)
    sc2 = 2
    cw = W * sc2
    gifs = []
    for t in range(NF):
        im = Image.new('RGBA', (cw * 4, cw * len(NAMES)), (0, 0, 0, 255))
        for ri, name in enumerate(NAMES):
            for ci, season in enumerate(SEASONS):
                tile = bg_tile(season, W, H)
                tile.alpha_composite(all_frames[(name, season)][t])
                im.paste(tile.resize((cw, cw), Image.NEAREST), (ci * cw, ri * cw))
        gifs.append(im.convert('RGB'))
    gifs[0].save(os.path.join(out, 'preview', 'sway_preview.gif'), save_all=True, append_images=gifs[1:],
                 duration=int(1000 / FPS), loop=0, optimize=False)

    # palette
    cols = {}
    for fr in all_frames.values():
        for im in fr:
            a = np.array(im)
            m = a[:, :, 3] == 255
            for c in map(lambda q: tuple(int(v) for v in q), a[m][:, :3]):
                cols[c] = cols.get(c, 0) + 1
    ordered = sorted(cols.keys(), key=lambda c: (sum(c)))
    with open(os.path.join(out, 'palette', 'palette.hex'), 'w') as f:
        f.write('\n'.join('%02x%02x%02x' % c for c in ordered) + '\n')
    n = len(ordered)
    cols_n = 24
    rows_n = (n + cols_n - 1) // cols_n
    pi = Image.new('RGB', (cols_n * 8, rows_n * 8), (0, 0, 0))
    pd = ImageDraw.Draw(pi)
    for i, c in enumerate(ordered):
        x, y = (i % cols_n) * 8, (i // cols_n) * 8
        pd.rectangle([x, y, x + 7, y + 7], fill=c)
    pi.save(os.path.join(out, 'palette', 'palette.png'))
    print('unique opaque colors:', n)
    return all_frames


if __name__ == '__main__':
    out = sys.argv[1] if len(sys.argv) > 1 else os.path.join(os.path.dirname(os.path.abspath(__file__)), '..')
    build(os.path.abspath(out))
