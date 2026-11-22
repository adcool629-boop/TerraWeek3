# -*- coding: utf-8 -*-
"""forest_b.py - ground plants, mushrooms, logs, stumps, branches, rocks, fruit decals, baskets, seamless ground tiles."""
import sys, math, random
sys.path.insert(0, '/home/claude/TopDown_Trees_Seasons_Pack/source')
sys.path.insert(0, '/home/claude/Forest_Env_Pack/source')
import numpy as np
from PIL import Image
import gen_trees as G
from gen_trees import Canvas, hx, pal, mix, bay, seed_of, NF, LEAF, TRUNK, SHADOW
from forest_a import FR, LEAF_P, GOLD_AUTUMN, RED_AUTUMN, WHITE_BL, WHITE_BL2, PINK_BL, spring, draw_fruit, SEASONS

SNOW = G.SNOW_PAL
SNOW_O = G.SNOW_OUT
BARK = pal('#241810', '#44301e', '#68482c', '#8c6a42', '#b08c5c')
BARK_D = pal('#1e1812', '#3a3024', '#584a38', '#7a6a52', '#9c8c70')
WOOD_END = pal('#5a3a1c', '#9c7040', '#d0a468', '#ecc888', '#fae4b0')
ROCK = pal('#1e2228', '#3c4450', '#6a7482', '#98a2b0', '#c8d0da')
ROCK_W = pal('#2a241e', '#52483c', '#82745e', '#aa9c84', '#d0c4aa')
MOSS = pal('#16341c', '#255a2c', '#3a8038', '#60a850', '#92d070')
DRY_MOSS = pal('#3a3418', '#5c5426', '#827638', '#a89a52', '#cabc78')
DEAD_LEAF = pal('#2a1608', '#5a3014', '#8a4e1c', '#b87830', '#dca44c')
DRY_GRASS = pal('#40361a', '#6c5c2c', '#9c8844', '#c4ae62', '#e4d088')
FERN = pal('#103a22', '#1c5c30', '#2c8040', '#4aa856', '#7acc78')
SHROOM_CAP = {'red': pal('#4a0c14', '#982028', '#d83c3c', '#ff7a6c', '#ffc8b8'),
              'brown': pal('#2a1608', '#5c3a1c', '#8a5c30', '#b4844c', '#d8ac78'),
              'orange': pal('#5a2808', '#b4501c', '#e88a30', '#ffc468', '#ffe8a8')}
STEM = pal('#6a5a48', '#a89478', '#d8c8a8', '#f0e4c8', '#fffaec')
FLOWERS = {'pink': pal('#5a1840', '#b83c80', '#ec6cb0', '#ffa8d4', '#ffe0ee'),
           'yellow': pal('#6a4a08', '#c89814', '#f0cc30', '#fff078', '#fffac0'),
           'blue': pal('#142060', '#2c48b4', '#5878ec', '#9cb4ff', '#d8e4ff'),
           'white': pal('#5a5a6a', '#b4b4c8', '#e8e8f4', '#ffffff', '#ffffff'),
           'red': pal('#4a0818', '#a01838', '#e03850', '#ff8a98', '#ffd0d4')}


def sw(t, x, A=1.0, ph=0.0):
    return A * math.sin(2 * math.pi * t / NF + x * 0.31 + ph)


def disk(S, cx, cy, rx, ry, p, layer, snowcap=0.0, seed=0, pat=0.0, mask=None):
    """shaded dome / flat ellipse, light top-left"""
    cells = []
    for y in range(int(cy - ry - 1), int(cy + ry + 2)):
        for x in range(int(cx - rx - 1), int(cx + rx + 2)):
            dx, dy = (x + .5 - cx) / rx, (y + .5 - cy) / ry
            d = dx * dx + dy * dy
            if d <= 1.0:
                if mask and not mask(x, y):
                    continue
                nz = math.sqrt(max(0, 1 - d))
                v = 0.5 + 0.42 * (-dx * 0.55 - dy * 0.65 + nz * 0.5) - 0.2 + (bay(x, y) - .5) * 0.2
                i = 1 if v < 0.28 else 2 if v < 0.52 else 3 if v < 0.78 else 4
                S.put(x, y, p[i], layer, p[0])
                cells.append((x, y, d))
    return cells


def shadow_ell(S, cx, cy, rx, ry, a=96):
    for y in range(int(cy - ry - 1), int(cy + ry + 2)):
        for x in range(int(cx - rx - 1), int(cx + rx + 2)):
            d = ((x + .5 - cx) / rx) ** 2 + ((y + .5 - cy) / ry) ** 2
            if d <= 1 and S.free(x, y):
                if d > .75 and bay(x, y) < .5:
                    continue
                S.put(x, y, G.SHADOW_COL, SHADOW, None, a)


def snow_ground(S, cx, cy, rx, ry):
    for y in range(int(cy - ry - 1), int(cy + ry + 2)):
        for x in range(int(cx - rx - 1), int(cx + rx + 2)):
            ang = math.atan2(y + .5 - cy, x + .5 - cx)
            e = 1 + .08 * math.sin(5 * ang + 1.1) + .05 * math.sin(11 * ang)
            d = math.hypot((x + .5 - cx) / rx, (y + .5 - cy) / ry)
            if d <= e and S.free(x, y):
                c = SNOW[3] if (y + .5 - cy) < 0 else SNOW[2]
                if d > .8 * e:
                    c = SNOW[2] if bay(x, y) < .6 else SNOW[1]
                S.put(x, y, c, SHADOW, None, 255)


def ground(S, season, cx, cy, rx, ry):
    if season == 'winter':
        snow_ground(S, cx, cy, rx + 2, ry + 1)
    shadow_ell(S, cx + 1.5, cy + 1, rx, ry)


def snow_cap(S, cells_layer_xy, thr=0.0):
    """convert top-facing pixels (upper-left) of layer into snow"""
    pass


def snowify(S, x0, y0, x1, y1, frac=0.5, layerset=(TRUNK, LEAF), seed=0):
    """turn pixels in the upper part of each column's visible run into snow"""
    for x in range(x0, x1 + 1):
        top = None
        for y in range(y0, y1 + 1):
            if S.layer[y, x] in layerset:
                top = y
                break
        if top is None:
            continue
        bot = top
        while bot + 1 <= y1 and S.layer[bot + 1, x] in layerset:
            bot += 1
        h = bot - top + 1
        n = max(1, int(round(h * frac * (0.75 + 0.5 * bay(x, 3)))))
        for k in range(n):
            y = top + k
            c = SNOW[4] if k == 0 else SNOW[3] if k < n - 1 else SNOW[2]
            if k == n - 1 and bay(x, y) < .5:
                c = SNOW[1]
            S.put(x, y, c, LEAF, SNOW_O)


# ----------------------------------------------------------------------------- blades / plants
def blade(S, x0, y0, ang, L, p, t, A, ph, layer=LEAF, thick=1, tip=None):
    """curved blade: points along arc, tip displaced by sway"""
    pts = []
    n = int(L)
    for i in range(n + 1):
        u = i / max(1, n)
        bend = ang + (sw(t, x0, A, ph) * 0.09 * u)
        x = x0 + math.sin(bend) * L * u + sw(t, x0, A, ph) * 1.6 * u * u
        y = y0 - math.cos(bend) * L * u
        pts.append((x, y, u))
    seen = set()
    for (x, y, u) in pts:
        xi, yi = int(round(x)), int(round(y))
        if (xi, yi) in seen:
            continue
        seen.add((xi, yi))
        ci = 1 if u < .25 else 2 if u < .6 else 3 if u < .92 else 4
        if tip is not None and u > .9:
            S.put(xi, yi, tip[2], layer, tip[0])
        else:
            S.put(xi, yi, p[ci], layer, p[0])
        if thick == 2:
            S.put(xi + 1, yi, p[max(1, ci - 1)], layer, p[0])


def season_green(season, kind='grass'):
    if kind == 'fern':
        base = FERN
        return {'spring': spring(base), 'summer': base,
                'autumn': pal('#4a2c10', '#8a5418', '#c08a28', '#dcb048', '#f0d078'),
                'winter': pal('#2a2a1c', '#4a4630', '#6a6444', '#8a8460', '#aaa47c')}[season]
    base = LEAF_P['bush']
    return {'spring': spring(base), 'summer': base, 'autumn': DRY_GRASS, 'winter': DRY_GRASS}[season]


def plant_grass(season, t, tall=False):
    S = Canvas()
    shadow_ell(S, 33, 56, 14 if not tall else 12, 3.6, 70)
    r = random.Random(seed_of('grass' + str(tall)))
    p = season_green(season)
    n = 15 if not tall else 12
    for i in range(n):
        x0 = 32 + (i - n / 2) * (26 / n) + r.uniform(-1, 1)
        L = r.uniform(10, 17) if tall else r.uniform(6, 11)
        ang = (x0 - 32) / 20 + r.uniform(-.2, .2)
        blade(S, int(x0), 57 - r.randint(0, 2), ang, L, p, t, 1.0, r.uniform(0, 3), thick=2 if tall else 1)
    if season == 'spring':
        for k in range(3):
            fx, fy = 22 + k * 10 + r.randint(-2, 2), 44 - r.randint(0, 5)
            S.put(fx, fy, WHITE_BL[3], LEAF, WHITE_BL[1]); S.put(fx + 1, fy, WHITE_BL[2], LEAF, WHITE_BL[1])
    if season == 'summer' and tall:
        for i in range(5):  # seed heads
            x0 = 24 + i * 4 + r.randint(-1, 1)
            S.put(x0 + int(sw(t, x0, 1, 0) * 1.5), 40 - r.randint(0, 4), DRY_GRASS[3], LEAF, DRY_GRASS[0])
    S.outline()
    if season == 'winter':
        snowify(S, 14, 30, 50, 58, 0.22)
    return S.image()


def plant_fern(season, t):
    S = Canvas()
    shadow_ell(S, 33, 56, 16, 4, 70)
    p = season_green(season, 'fern')
    cx, cy = 32, 56
    fronds = [(-80, 15), (-55, 21), (-28, 24), (0, 22), (28, 24), (55, 21), (80, 15)]
    for ang, L in fronds:
        a = math.radians(ang)
        n = int(L)
        for i in range(n):
            u = i / n
            bend = a + sw(t, ang, 1, .4) * .05 * u + (u * u * (.55 if ang > 0 else -.55 if ang < 0 else 0))
            x = cx + math.sin(bend) * L * u
            y = cy - math.cos(bend) * L * u * .75 + u * u * 4
            S.put(int(round(x)), int(round(y)), p[2 if u < .8 else 3], LEAF, p[0])
            # leaflets
            if i % 2 == 0 and 0.12 < u < 0.95:
                w = int((1 - u) * 4) + 1
                px, py = -math.cos(bend), -math.sin(bend) * .6
                for s_ in (-1, 1):
                    for k in range(1, w + 1):
                        S.put(int(round(x + s_ * k)), int(round(y + k * .35)), p[1 + (k > 1) + (s_ < 0 and 0)], LEAF, p[0])
    S.outline()
    if season == 'winter':
        snowify(S, 8, 30, 56, 58, 0.25)
    return S.image()


def plant_flowers(season, t, col='pink'):
    S = Canvas()
    shadow_ell(S, 33, 56, 14, 3.6, 70)
    r = random.Random(seed_of('fl' + col))
    p = season_green(season)
    fp = FLOWERS[col]
    for i in range(14):
        x0 = 20 + i * 1.7 + r.uniform(-1, 1)
        blade(S, int(x0), 57, (x0 - 32) / 25 + r.uniform(-.15, .15), r.uniform(7, 13), p, t, .9, r.uniform(0, 3))
    n = {'spring': 8, 'summer': 11, 'autumn': 3, 'winter': 0}[season]
    for i in range(n):
        x0 = 21 + (i * 23 // max(1, n)) + r.randint(0, 3)
        L = r.uniform(11, 20)
        bend = (x0 - 32) / 28
        xt = x0 + math.sin(bend) * L + sw(t, x0, 1, 1) * 1.4
        yt = 57 - math.cos(bend) * L
        for k in range(int(L)):
            u = k / L
            S.put(int(x0 + math.sin(bend) * L * u + sw(t, x0, 1, 1) * 1.4 * u * u), int(57 - math.cos(bend) * L * u), p[2], LEAF, p[0])
        xt, yt = int(xt), int(yt)
        if season == 'autumn':
            q = pal('#3a2a18', '#6a4a28', '#8c6a40', '#b08c5c', '#d0b080')
            S.put(xt, yt, q[3], LEAF, q[0]); S.put(xt, yt - 1, q[2], LEAF, q[0])
            continue
        for dx, dy in ((-1, 0), (1, 0), (0, -1), (0, 1)):
            S.put(xt + dx, yt + dy, fp[2 + ((dx + dy) % 2 == 0)], LEAF, fp[0])
        S.put(xt, yt, fp[4] if col != 'yellow' else hx('#c87818'), LEAF, fp[0])
    S.outline()
    if season == 'winter':
        snowify(S, 14, 40, 50, 58, 0.3)
    return S.image()


def plant_mushrooms(season, t, kind='red'):
    S = Canvas()
    shadow_ell(S, 33, 56, 14, 3.5, 80)
    cap = SHROOM_CAP[kind]
    mounts = [(24, 53, 5, 3), (35, 51, 7, 4), (44, 54, 4, 2.5)]
    for k, (x, y, rx, ry) in enumerate(mounts):
        rx_, ry_ = rx, ry
        if season == 'winter':
            cap_ = pal('#2a2a30', '#4a4a56', '#6a6a78', '#8c8c9a', '#aeaebc')
        else:
            cap_ = cap
        sh = int(ry_ * 1.5)
        for yy in range(int(y), int(y) + sh + 1):          # stem
            for xx in (int(x) - 1, int(x), int(x) + 1):
                if xx == int(x) - 1:
                    c = STEM[2]
                elif xx == int(x):
                    c = STEM[3]
                else:
                    c = STEM[1]
                S.put(xx, yy, c, LEAF, STEM[0])
        disk(S, x, y, rx_, ry_, cap_, LEAF)
        if kind == 'red' and season != 'winter':
            for (ax, ay) in ((-1, -1), (2, 0), (0, 1)):
                if rx >= 5:
                    S.put(int(x) + ax, int(y) + ay, cap[4], LEAF, cap[0])
    S.outline()
    if season == 'winter':
        snowify(S, 14, 40, 52, 58, 0.45)
    return S.image()


def plant_clover(season, t):
    S = Canvas()
    shadow_ell(S, 33, 54, 15, 3.6, 50)
    p = season_green(season)
    r = random.Random(11)
    if season == 'winter':
        p = pal('#3c3c2c', '#5c5c40', '#7c7c58', '#9c9c72', '#bcbc8c')
    for i in range(22):
        x, y = int(r.gauss(32, 7)), int(r.gauss(52, 2.6))
        for dx, dy in ((-1, 0), (1, 0), (0, -1)):
            S.put(x + dx, y + dy, p[2 + ((x + dx + y) & 1)], LEAF, p[0])
        S.put(x, y, p[3], LEAF, p[0])
        if season in ('spring', 'summer') and i % 5 == 0:
            S.put(x, y - 1, WHITE_BL[4], LEAF, WHITE_BL[1])
    S.outline()
    if season == 'winter':
        snowify(S, 14, 40, 52, 58, 0.5)
    return S.image()


def plant_leaflitter(season, t):
    S = Canvas()
    r = random.Random(seed_of('litter' + season))
    cols = {'spring': [pal('#3c2a14', '#6c4a24', '#8c6a38', '#b08c58', '#d0b078'), pal('#1c4a22', '#2c7234', '#4a9a46', '#78c25c', '#a8e480')],
            'summer': [pal('#14401e', '#24642e', '#3c8c40', '#64b454', '#9cdc78')],
            'autumn': [DEAD_LEAF, RED_AUTUMN, GOLD_AUTUMN, pal('#5a2a10', '#9a4a1c', '#cc6a2c', '#e8923c', '#f8b868')],
            'winter': [pal('#3a2a1c', '#5a4430', '#7a5e44', '#9c8060', '#bca280')]}[season]
    n = {'spring': 10, 'summer': 7, 'autumn': 22, 'winter': 12}[season]
    for i in range(n):
        x, y = int(r.gauss(32, 8)), int(r.gauss(52, 3))
        p = r.choice(cols)
        sh = r.choice([[(0, 0), (1, 0), (2, 0), (1, 1)], [(0, 0), (1, 0), (1, 1), (2, 1)], [(0, 0), (1, 0), (0, 1)], [(0, 0), (1, 0), (2, 0), (3, 1)]])
        for k, (dx, dy) in enumerate(sh):
            S.put(x + dx, y + dy, p[3 if k == 0 else 2 if k < 3 else 1], LEAF, p[0])
    S.outline()
    if season == 'winter':
        snowify(S, 14, 40, 52, 58, 0.45, seed=3)
    return S.image()


def plant_moss(season, t):
    S = Canvas()
    r = random.Random(seed_of('moss'))
    p = {'spring': MOSS, 'summer': MOSS, 'autumn': pal('#2a3418', '#44581e', '#5e7a2c', '#84a040', '#acc860'), 'winter': DRY_MOSS}[season]
    for (cx, cy, rx, ry) in [(26, 52, 9, 4), (38, 51, 8, 4), (32, 54, 10, 3.4)]:
        disk(S, cx, cy, rx, ry, p, LEAF)
    for i in range(10):
        x, y = int(r.gauss(32, 8)), int(r.gauss(52, 2.5))
        S.put(x, y, p[4], LEAF, p[0])
    S.outline()
    if season == 'winter':
        snowify(S, 14, 40, 52, 58, 0.55)
    return S.image()


def plant_reeds(season, t):
    S = Canvas()
    shadow_ell(S, 33, 56, 13, 3.4, 70)
    r = random.Random(seed_of('reed'))
    p = {'spring': pal('#1c4a24', '#2c7234', '#4c9a44', '#7cc45c', '#b0e888'), 'summer': pal('#1c4a24', '#2c7234', '#4c9a44', '#7cc45c', '#b0e888'),
         'autumn': pal('#4a3a18', '#7a6228', '#a88a3c', '#cdb05a', '#ecd482'), 'winter': pal('#3a3424', '#5c5238', '#7c7052', '#9c9070', '#bcb090')}[season]
    for i in range(9):
        x0 = 22 + i * 2.6 + r.uniform(-1, 1)
        L = r.uniform(24, 34)
        ang = (x0 - 32) / 40
        blade(S, int(x0), 57, ang, L, p, t, 1.4, r.uniform(0, 2))
        if season != 'spring' and i % 3 == 0:     # cattail head
            xt = int(x0 + math.sin(ang) * L * .66 + sw(t, x0, 1.4, 0) * 1.6 * .44)
            yt = int(57 - math.cos(ang) * L * .66)
            c = pal('#2a1608', '#5a3014', '#7c4a20', '#a06a34', '#c08a50')
            for dy in range(-3, 1):
                S.put(xt, yt + dy, c[2], LEAF, c[0]); S.put(xt + 1, yt + dy, c[1], LEAF, c[0])
            S.put(xt, yt - 3, c[3], LEAF, c[0])
    S.outline()
    if season == 'winter':
        snowify(S, 14, 20, 50, 58, 0.12)
    return S.image()


# ----------------------------------------------------------------------------- logs, stumps, branches
def rings(S, cx, cy, rx, ry, p=WOOD_END, layer=TRUNK, split=False):
    for y in range(int(cy - ry - 1), int(cy + ry + 2)):
        for x in range(int(cx - rx - 1), int(cx + rx + 2)):
            dx, dy = (x + .5 - cx) / rx, (y + .5 - cy) / ry
            d = math.hypot(dx, dy)
            if d <= 1.0:
                ring = int(d * 3.2 + .3) % 2
                v = 0.5 - (dx * .35 + dy * .4)
                i = 3 if ring == 0 else 2
                if d > .86:
                    i = 1
                if d < .12:
                    i = 1
                if v > .78 and i == 3:
                    i = 4
                S.put(x, y, p[i], layer, BARK[0])


def stump(season, t=0, axe=False, tall=False, mossy=False):
    S = Canvas()
    ground(S, season, 33, 56, 15, 4.4)
    cx, cy, rx, ry = 32, 44 if not tall else 38, 11, 5.4
    h = 11 if not tall else 17
    bark = BARK
    # trunk side
    for y in range(int(cy), int(cy + h) + 1):
        for x in range(int(cx - rx), int(cx + rx) + 1):
            dx = (x + .5 - cx) / rx
            lim = ry * math.sqrt(max(0, 1 - dx * dx))
            if y <= cy + lim * 0 + h + lim:
                if y > cy + lim * 0 + 0 and y <= cy + h + lim:
                    pass
    for x in range(int(cx - rx), int(cx + rx) + 1):
        dx = (x + .5 - cx) / rx
        if abs(dx) > 1:
            continue
        lim = ry * math.sqrt(1 - dx * dx)
        for y in range(int(cy), int(cy + h + lim) + 1):
            u = (dx + 1) / 2
            i = 1 if u > .72 else 2 if u > .38 else 3
            if (x * 3 + y // 2) % 5 == 0:
                i = max(1, i - 1)
            if u < .12:
                i = 4 if (y % 3) else 3
            S.put(x, y, bark[i], TRUNK, bark[0])
    # roots
    for (rx0, d) in ((-1, -1), (1, 1)):
        for k in range(4):
            S.put(int(cx + rx0 * (rx - 1 + k)), int(cy + h + ry * .7 + (k > 1)), bark[1], TRUNK, bark[0])
    rings(S, cx, cy, rx, ry)
    if mossy:
        mp = MOSS if season in ('spring', 'summer', 'autumn') else DRY_MOSS
        for x in range(int(cx - rx), int(cx - 1)):
            for y in range(int(cy + ry * .4), int(cy + h + 3)):
                if S.layer[y, x] == TRUNK and bay(x + 2, y) < .35 + (cx - x) * -.02:
                    S.put(x, y, mp[2 + (bay(x, y) > .5)], LEAF, mp[0])
    if axe:
        for k in range(14):                      # handle
            S.put(int(cx + 6 + k * .45), int(cy - 7 + k * .5), WOOD_END[2], LEAF, BARK[0])
            S.put(int(cx + 7 + k * .45), int(cy - 7 + k * .5), WOOD_END[1], LEAF, BARK[0])
        AX = pal('#20242c', '#4a525e', '#7c8694', '#aab4c0', '#e0e8f0')
        for (dx, dy, i) in [(-4, -8, 3), (-3, -8, 4), (-2, -8, 3), (-1, -8, 2), (0, -8, 2), (-4, -7, 3), (-3, -7, 3), (-2, -7, 2), (-1, -7, 2),
                            (0, -7, 1), (-3, -6, 2), (-2, -6, 2), (-1, -6, 1), (0, -6, 1), (-4, -9, 2), (-3, -9, 3), (-2, -9, 3)]:
            S.put(int(cx + 7 + dx), int(cy + 1 + dy + 7), AX[i], LEAF, AX[0])
    S.outline()
    if season == 'winter':
        snowify(S, 12, 20, 52, 60, 0.0)
        # snow on top disc
        for y in range(int(cy - ry), int(cy + ry) + 1):
            for x in range(int(cx - rx), int(cx + rx) + 1):
                dx, dy = (x + .5 - cx) / (rx - 1), (y + .5 - cy) / (ry - .6)
                if dx * dx + dy * dy <= 1 and dy < .55 and S.layer[y, x] in (TRUNK, LEAF):
                    c = SNOW[4] if dx + dy < 0 else SNOW[3]
                    if dx * dx + dy * dy > .7:
                        c = SNOW[2]
                    S.put(x, y, c, LEAF, SNOW_O)
    if season == 'autumn':
        leaves(S, 6, seed_of('stl'), 22, 50, 20, 8)
    if season == 'spring':
        shoot = FERN
        if not tall:
            S.put(20, 49, shoot[3], LEAF, shoot[0]); S.put(20, 48, shoot[2], LEAF, shoot[0]); S.put(21, 48, shoot[3], LEAF, shoot[0])
    return S.image()


def leaves(S, n, seed, x0, y0, w, h):
    r = random.Random(seed)
    cols = [DEAD_LEAF, RED_AUTUMN, GOLD_AUTUMN]
    for i in range(n):
        x, y = x0 + r.randint(0, w), y0 + r.randint(0, h)
        p = r.choice(cols)
        if S.free(x, y) and S.free(x + 1, y):
            S.put(x, y, p[3], LEAF, p[0]); S.put(x + 1, y, p[2], LEAF, p[0])
            if r.random() < .5 and S.free(x, y + 1):
                S.put(x, y + 1, p[1], LEAF, p[0])


def log_h(S, x0, y0, L, R, bark=BARK, end='left', hollow=False, tilt=0.0):
    """horizontal log: body from x0..x0+L, center y0, radius R"""
    for x in range(x0, x0 + L + 1):
        yc = y0 + tilt * (x - x0)
        for y in range(int(yc - R), int(yc + R) + 1):
            dy = (y + .5 - yc) / (R + .5)
            if abs(dy) > 1:
                continue
            u = (dy + 1) / 2
            i = 4 if u < .14 else 3 if u < .38 else 2 if u < .64 else 1
            if (x * 2 + int(u * 7)) % 7 == 0 and i > 1:
                i -= 1
            if (x + y * 3) % 11 == 0:
                i = max(1, i - 1)
            S.put(x, y, bark[i], TRUNK, bark[0])
    ex = x0 if end == 'left' else x0 + L
    rings(S, ex, y0, R * .55 + .8, R + .4, layer=TRUNK)
    if hollow:
        for y in range(int(y0 - R * .6), int(y0 + R * .6) + 1):
            for x in range(int(ex - R * .45), int(ex + R * .45) + 1):
                dx, dy = (x + .5 - ex) / (R * .45), (y + .5 - y0) / (R * .6)
                if dx * dx + dy * dy <= 1:
                    S.put(x, y, hx('#0e0a08') if dx + dy > -.2 else hx('#241810'), TRUNK, BARK[0])


def log(season, t=0, kind='single'):
    S = Canvas()
    ground(S, season, 33, 54, 22, 5.4)
    if kind == 'single':
        log_h(S, 12, 48, 38, 6)
    elif kind == 'mossy':
        log_h(S, 12, 48, 38, 6)
        mp = MOSS if season != 'winter' else DRY_MOSS
        for x in range(14, 50):
            for y in range(41, 48):
                if S.layer[y, x] == TRUNK and (bay(x, y) < .55 and (x * 7 + y * 3) % 5 < 3):
                    S.put(x, y, mp[2 + (y % 2)] if bay(x + 1, y) > .3 else mp[3], LEAF, mp[0])
    elif kind == 'hollow':
        log_h(S, 11, 46, 40, 8, hollow=True)
    elif kind == 'branch_log':
        log_h(S, 10, 49, 40, 5, tilt=-.05)
        # stub branches
        for (bx, by) in ((24, 43), (36, 42)):
            for k in range(4):
                S.put(bx + k // 2, by - k, BARK[2 + (k % 2)], TRUNK, BARK[0]); S.put(bx + 1 + k // 2, by - k, BARK[1], TRUNK, BARK[0])
            S.put(bx, by - 4, WOOD_END[3], TRUNK, BARK[0]); S.put(bx + 1, by - 4, WOOD_END[2], TRUNK, BARK[0])
    elif kind == 'vertical':
        # upright log leaning, seen from above 3/4: tall cylinder
        cx, cy, rx, ry = 32, 28, 9, 4.4
        for x in range(cx - rx, cx + rx + 1):
            dx = (x + .5 - cx) / rx
            if abs(dx) > 1:
                continue
            lim = ry * math.sqrt(1 - dx * dx)
            for y in range(int(cy), int(52 + lim) + 1):
                u = (dx + 1) / 2
                i = 1 if u > .72 else 2 if u > .38 else 3
                if u < .12:
                    i = 4
                if (x * 3 + y // 3) % 5 == 0:
                    i = max(1, i - 1)
                S.put(x, y, BARK[i], TRUNK, BARK[0])
        rings(S, cx, cy, rx, ry)
    S.outline()
    if season == 'winter':
        if kind == 'vertical':
            for y in range(24, 33):
                for x in range(22, 42):
                    dx, dy = (x + .5 - 32) / 8, (y + .5 - 28) / 3.8
                    if dx * dx + dy * dy <= 1 and S.layer[y, x] in (TRUNK, LEAF):
                        S.put(x, y, SNOW[4] if dx + dy < 0 else SNOW[3], LEAF, SNOW_O)
        else:
            snowify(S, 8, 38, 54, 58, 0.42)
    if season == 'autumn':
        leaves(S, 8, seed_of('ll' + kind), 12, 38, 38, 18)
    if season == 'spring' and kind in ('single', 'mossy', 'hollow'):
        S.put(41, 40 if kind != 'hollow' else 36, PINK_BL[3], LEAF, PINK_BL[1]) if False else None
    return S.image()


def log_pile(season, t=0):
    S = Canvas()
    ground(S, season, 33, 54, 22, 5.6)
    log_h(S, 11, 51, 36, 5)
    log_h(S, 14, 41, 34, 5)
    log_h(S, 12, 31, 34, 5, end='left')
    # end faces on right side too
    for (x1, y1) in ((47, 51), (48, 41), (46, 31)):
        rings(S, x1, y1, 3.4, 5.4)
    S.outline()
    if season == 'winter':
        snowify(S, 8, 24, 56, 58, 0.34)
    if season == 'autumn':
        leaves(S, 7, seed_of('lp'), 8, 22, 44, 34)
    return S.image()


def firewood(season, t=0):
    S = Canvas()
    ground(S, season, 33, 54, 17, 4.8)
    short = [(22, 52), (31, 52), (40, 52), (26, 46), (36, 46), (31, 40)]
    for (x, y) in short:
        # short vertical piece: side plus end ring
        for xx in range(x - 4, x + 5):
            dx = (xx + .5 - x) / 4.5
            if abs(dx) > 1:
                continue
            lim = 2.6 * math.sqrt(1 - dx * dx)
            for yy in range(int(y - 5), int(y + lim) + 1):
                u = (dx + 1) / 2
                i = 1 if u > .72 else 2 if u > .38 else 3
                S.put(xx, yy, BARK[i], TRUNK, BARK[0])
        rings(S, x, y - 5, 4.5, 2.6)
    # binding rope
    for xx in range(17, 47):
        yy = 50
        if S.layer[yy, xx] == TRUNK and S.layer[yy, xx] != 0 and xx % 2 == 0:
            S.put(xx, yy, hx('#b8a070'), TRUNK, BARK[0])
    S.outline()
    if season == 'winter':
        snowify(S, 14, 32, 52, 58, 0.22)
    return S.image()


def twig_line(S, p0, p1, p, layer=TRUNK):
    n = int(max(abs(p1[0] - p0[0]), abs(p1[1] - p0[1]))) + 1
    for i in range(n + 1):
        u = i / max(1, n)
        x = int(round(p0[0] + (p1[0] - p0[0]) * u))
        y = int(round(p0[1] + (p1[1] - p0[1]) * u))
        S.put(x, y, p[3 if u < .5 else 2], layer, p[0])
        if i % 2 == 0:
            S.put(x, y + 1, p[1], layer, p[0])


def branches(season, t=0, kind='fork'):
    S = Canvas()
    ground(S, season, 33, 54, 20, 4.2)
    p = BARK
    if kind == 'fork':
        twig_line(S, (10, 52), (30, 48), p)
        twig_line(S, (30, 48), (46, 42), p)
        twig_line(S, (30, 48), (42, 52), p)
        twig_line(S, (22, 50), (28, 56), p)
        twig_line(S, (38, 45), (52, 47), p)
    elif kind == 'twigs':
        twig_line(S, (14, 50), (34, 54), p)
        twig_line(S, (22, 46), (46, 49), p)
        twig_line(S, (28, 56), (50, 54), p)
        twig_line(S, (36, 51), (44, 44), p)
        twig_line(S, (18, 54), (24, 49), p)
    elif kind == 'big':
        log_h(S, 8, 50, 40, 3, tilt=-.04)
        twig_line(S, (24, 49), (34, 40), p)
        twig_line(S, (34, 40), (42, 38), p)
        twig_line(S, (34, 40), (38, 33), p)
        twig_line(S, (40, 47), (52, 44), p)
    S.outline()
    if season == 'winter':
        snowify(S, 6, 28, 58, 58, 0.45)
    if season == 'autumn':
        leaves(S, 6, seed_of('br' + kind), 8, 40, 42, 16)
    if season in ('spring', 'summer') and kind == 'big':
        for (x, y) in ((24, 44), (38, 36)):
            LP = LEAF_P['apple']
            for dx, dy in ((0, 0), (1, 0), (0, -1), (1, -1)):
                S.put(x + dx, y + dy, LP[3 if (dx + dy) % 2 else 2], LEAF, LP[0])
    return S.image()


# ----------------------------------------------------------------------------- rocks
def rock_shape(S, cx, cy, rx, ry, p, seed, facets=6, moss=False, season='summer', flat=False):
    r = random.Random(seed)
    ph = [r.uniform(0, 6.28) for _ in range(3)]
    am = [r.uniform(.07, .14), r.uniform(.04, .09), r.uniform(.02, .05)]
    for y in range(int(cy - ry - 3), int(cy + ry + 3)):
        for x in range(int(cx - rx - 3), int(cx + rx + 3)):
            dx, dy = (x + .5 - cx) / rx, (y + .5 - cy) / ry
            ang = math.atan2(dy, dx)
            lim = 1 + am[0] * math.sin(3 * ang + ph[0]) + am[1] * math.sin(5 * ang + ph[1]) + am[2] * math.sin(9 * ang + ph[2])
            d = math.hypot(dx, dy) / lim
            if d <= 1:
                nz = math.sqrt(max(0, 1 - d * d)) if not flat else .75 - .25 * d
                fa = math.floor((ang + 3.1416) / 6.2832 * facets)
                fv = (math.sin(fa * 2.4 + seed) * .5) * .16
                v = .5 + .5 * (-dx * .5 - dy * .62) * (1 - .3 * nz) + nz * .22 - .13 + fv + (bay(x, y) - .5) * .1
                i = 1 if v < .30 else 2 if v < .52 else 3 if v < .76 else 4
                S.put(x, y, p[i], LEAF, p[0])
                # crack
                if (int(dx * 5 + dy * 3 + seed) % 7 == 0) and d > .25 and d < .8 and i > 1 and bay(x, y) < .22:
                    S.put(x, y, p[i - 1], LEAF, p[0])
    if moss:
        mp = MOSS if season != 'winter' else DRY_MOSS
        for y in range(int(cy - ry - 2), int(cy + ry + 2)):
            for x in range(int(cx - rx - 2), int(cx + rx + 2)):
                if S.layer[y, x] == LEAF and (y - cy) < ry * .1 and (x - cx) < rx * .45:
                    k = bay(x * 3, y * 2 + 1)
                    if k < .55 - (y - (cy - ry)) * .03:
                        S.put(x, y, mp[2 + (k < .27) + (k < .1)], LEAF, mp[0])


def rock(season, t, kind):
    S = Canvas()
    p = ROCK
    spec = {'pebbles': None, 'small': (3.8, 3.0), 'medium': (8, 6), 'boulder': (14, 11), 'slab': (14, 5.5), 'mossy': (10, 7.5), 'mossyb': (15, 11.5)}
    if kind == 'pebbles':
        ground(S, season, 33, 55, 13, 3.4)
        for (x, y, rx, ry, pp, sd) in [(24, 54, 3.4, 2.4, ROCK, 1), (33, 52, 4.2, 3, ROCK_W, 2), (42, 55, 3.2, 2.2, ROCK, 3), (29, 57, 2.4, 1.8, ROCK_W, 4), (38, 49, 2.2, 1.6, ROCK, 5)]:
            rock_shape(S, x, y, rx, ry, pp, sd, facets=4)
    elif kind == 'small':
        ground(S, season, 33, 54, 8, 3.2)
        rock_shape(S, 32, 52, 5.2, 4.0, ROCK_W, 21, 5)
    elif kind == 'medium':
        ground(S, season, 34, 54, 13, 4)
        rock_shape(S, 32, 50, 9, 7, ROCK, 31, 6)
    elif kind == 'boulder':
        ground(S, season, 35, 56, 20, 5)
        rock_shape(S, 32, 47, 15, 12, ROCK, 41, 7)
    elif kind == 'slab':
        ground(S, season, 34, 55, 19, 4.4)
        rock_shape(S, 32, 51, 15, 6, ROCK_W, 51, 7, flat=True)
    elif kind == 'mossy':
        ground(S, season, 34, 55, 15, 4.6)
        rock_shape(S, 32, 50, 11, 8, ROCK, 61, 6, moss=True, season=season)
    elif kind == 'mossyb':
        ground(S, season, 35, 57, 21, 5)
        rock_shape(S, 32, 46, 16, 13, ROCK_W, 71, 7, moss=True, season=season)
    elif kind == 'cairn':
        ground(S, season, 34, 56, 14, 4.4)
        rock_shape(S, 32, 52, 11, 5.8, ROCK, 81, 6)
        rock_shape(S, 33, 45, 8, 4.8, ROCK_W, 82, 6)
        rock_shape(S, 32, 39, 5.6, 3.8, ROCK, 83, 5)
        rock_shape(S, 33, 34, 3.4, 2.6, ROCK_W, 84, 4)
    S.outline()
    if season == 'winter':
        if kind == 'pebbles':
            snowify(S, 14, 40, 52, 60, 0.35)
        else:
            snowify(S, 8, 14, 58, 60, 0.38)
    if season == 'autumn':
        leaves(S, 4 if kind in ('pebbles', 'small') else 7, seed_of('rl' + kind), 14, 36, 36, 20)
    if season == 'spring' and kind in ('mossy', 'mossyb', 'medium', 'boulder'):
        fp = FLOWERS['white']
        for (x, y) in ((22, 55), (44, 56), (39, 58)):
            S.put(x, y, fp[3], LEAF, fp[1]); S.put(x + 1, y, FLOWERS['yellow'][3], LEAF, fp[1])
    return S.image()


# ----------------------------------------------------------------------------- decals
def fallen_fruit(season, t, name):
    S = Canvas()
    r = random.Random(seed_of('ff' + name))
    ground(S, season, 33, 54, 11, 3.2)
    recs = {'apple': ([FR['apple_red'], FR['apple_green'], FR['apple_yellow']], 4), 'orange': ([FR['orange'], FR['orange_mix']], 4),
            'mulberry': ([FR['mulb_red'], FR['mulb_dark']], 2)}
    pl, size = recs[name]
    if season == 'winter':
        pl = [FR['apple_dried'] if name == 'apple' else FR['mulb_dried'] if name == 'mulberry' else FR['orange']]
    n = 4 if size == 4 else 11
    pos = [(24, 52), (32, 49), (40, 53), (30, 55)] if size == 4 else None
    for i in range(n):
        if pos:
            x, y = pos[i]
        else:
            x, y = int(r.gauss(32, 6)), int(r.gauss(53, 2.4))
        draw_fruit(S, x, y, pl[i % len(pl)], size)
    if season in ('spring', 'summer'):
        LP = LEAF_P['apple']
        for (x, y) in ((27, 56), (37, 51)):
            S.put(x, y, LP[3], LEAF, LP[0]); S.put(x + 1, y, LP[2], LEAF, LP[0])
    S.outline()
    if season == 'winter':
        snowify(S, 14, 40, 52, 60, 0.22)
    if season == 'autumn':
        leaves(S, 5, seed_of('fl2' + name), 16, 44, 30, 12)
    return S.image()


def basket(season, t, content):
    S = Canvas()
    ground(S, season, 33, 54, 14, 4)
    W1 = pal('#3a2410', '#6c4620', '#a06c34', '#c8944c', '#e8b870')
    cx, cy = 32, 46
    for x in range(cx - 10, cx + 11):
        dx = (x + .5 - cx) / 10.5
        if abs(dx) > 1:
            continue
        lim = 4.4 * math.sqrt(1 - dx * dx)
        for y in range(int(cy), int(cy + 8 + lim) + 1):
            u = (dx + 1) / 2
            i = 1 if u > .74 else 2 if u > .4 else 3
            if (x + y) % 3 == 0 or (x - y) % 4 == 0:
                i = max(1, i - 1)
            S.put(x, y, W1[i], TRUNK, W1[0])
    # inner + fruit
    disk(S, cx, cy, 10, 4.4, pal('#241608', '#3a2410', '#4c3016', '#5c3c1c', '#6c4824'), TRUNK)
    r = random.Random(5)
    if content == 'apples':
        pl = [FR['apple_red'], FR['apple_green'], FR['apple_yellow']]
        spots = [(22, 41), (28, 38), (34, 40), (39, 42), (26, 44), (32, 44), (37, 38)]
        for i, (x, y) in enumerate(spots):
            draw_fruit(S, x, y, pl[i % 3 if season != 'autumn' else (0 if i % 3 else 2)], 4)
    elif content == 'oranges':
        pl = [FR['orange'], FR['orange_mix']]
        for i, (x, y) in enumerate([(22, 41), (28, 38), (34, 40), (39, 42), (26, 44), (32, 44), (37, 38)]):
            draw_fruit(S, x, y, pl[i % 2], 4)
    elif content == 'berries':
        pl = [FR['mulb_red'], FR['mulb_dark'], FR['blue'], FR['rasp']]
        for i in range(34):
            x, y = int(r.gauss(32, 5.5)), int(r.gauss(44, 1.9))
            if abs(x - 32) < 9:
                S.put(x, y, pl[i % 4][3], LEAF, pl[i % 4][0]); S.put(x + 1, y, pl[i % 4][2], LEAF, pl[i % 4][0]); S.put(x, y + 1, pl[i % 4][1], LEAF, pl[i % 4][0])
    # handle
    for k in range(-9, 10):
        yy = int(cy - 9 + (k * k) / 14.0)
        S.put(cx + k, yy, W1[3 if k < 0 else 2], TRUNK, W1[0])
        S.put(cx + k, yy + 1, W1[1], TRUNK, W1[0])
    S.outline()
    if season == 'winter':
        snowify(S, 20, 30, 44, 36, 0.2)
    return S.image()


# ----------------------------------------------------------------------------- tiles
def _hash2(ix, iy, s):
    n = (ix * 374761393 + iy * 668265263 + s * 2147483647) & 0xFFFFFFFF
    n = (n ^ (n >> 13)) * 1274126177 & 0xFFFFFFFF
    return ((n ^ (n >> 16)) & 0xFFFF) / 65535.0


def vnoise(x, y, s, per):
    x0, y0 = int(math.floor(x)), int(math.floor(y))
    fx, fy = x - x0, y - y0
    fx, fy = fx * fx * (3 - 2 * fx), fy * fy * (3 - 2 * fy)

    def h(a, b):
        return _hash2(a % per, b % per, s)
    return (h(x0, y0) * (1 - fx) + h(x0 + 1, y0) * fx) * (1 - fy) + (h(x0, y0 + 1) * (1 - fx) + h(x0 + 1, y0 + 1) * fx) * fy


TILE_PAL = {
    'grass': {'spring': pal('#4e8a34', '#68a444', '#82bc54', '#9ccc6c', '#b8e088'), 'summer': pal('#3c7c2c', '#52963a', '#68ac46', '#82c25a', '#a0d874'),
              'autumn': pal('#7a6a2c', '#98863a', '#b4a04a', '#ccb85e', '#e0d078'), 'winter': pal('#b4c8dc', '#c8d8e8', '#dae6f2', '#eaf2fa', '#fafeff')},
    'forest': {'spring': pal('#34522a', '#44683a', '#587e48', '#6e9458', '#88aa6c'), 'summer': pal('#2c4826', '#3a5e30', '#4c7440', '#608a50', '#78a064'),
               'autumn': pal('#4c3a20', '#665030', '#82683e', '#9c824c', '#b89c60'), 'winter': pal('#a4b4c8', '#b8c6d8', '#ccd8e6', '#dee8f2', '#f0f6fc')},
    'dirt': {'spring': pal('#5a4230', '#725638', '#8a6c46', '#a2845a', '#bc9e72'), 'summer': pal('#644a34', '#7e5e3e', '#987650', '#b28e62', '#ccaa7c'),
             'autumn': pal('#54402c', '#6c5238', '#846848', '#9c8058', '#b69a70'), 'winter': pal('#7a6a60', '#908074', '#a89a8c', '#c4b8ac', '#e0d8d0')},
    'moss': {'spring': pal('#2c5c2a', '#3a7434', '#4c8c40', '#62a450', '#7cbc66'), 'summer': pal('#245426', '#306a30', '#408238', '#549a48', '#6cb25c'),
             'autumn': pal('#40502a', '#566838', '#6e8044', '#889856', '#a4b26c'), 'winter': pal('#8ca094', '#a0b4a8', '#b8c8bc', '#d0dcd2', '#e8f0ea')},
}


def tile(season, kind, t=0):
    P = TILE_PAL[kind][season]
    s0 = seed_of('tile' + kind)
    per = 8
    arr = np.zeros((64, 64, 4), np.uint8)
    for y in range(64):
        for x in range(64):
            n = vnoise(x / 8.0, y / 8.0, s0, per) * .6 + vnoise(x / 4.0, y / 4.0, s0 + 7, 16) * .3 + vnoise(x / 2.0, y / 2.0, s0 + 13, 32) * .1
            v = n + (bay(x, y) - .5) * .12
            i = 0 if v < .30 else 1 if v < .44 else 2 if v < .58 else 3 if v < .72 else 4
            if kind == 'dirt':
                i = max(0, min(4, i))
            arr[y, x, :3] = P[i]
            arr[y, x, 3] = 255
    r = random.Random(s0)

    def stamp(x, y, c, w=1, h=1):
        for dy in range(h):
            for dx in range(w):
                arr[(y + dy) % 64, (x + dx) % 64, :3] = c

    if kind == 'grass':
        for i in range(70):
            x, y = r.randrange(64), r.randrange(64)
            if season == 'winter':
                stamp(x, y, hx('#8fa66a') if i % 3 == 0 else P[4], 1, 2 if i % 3 == 0 else 1)
            else:
                stamp(x, y, P[4], 1, 2); stamp(x, y + 2, P[0])
        if season == 'spring':
            for i in range(14):
                c = r.choice([hx('#ffffff'), hx('#ffe060'), hx('#ff9ac8')])
                stamp(r.randrange(64), r.randrange(64), c)
        if season == 'autumn':
            for i in range(22):
                c = r.choice([DEAD_LEAF[3], RED_AUTUMN[3], GOLD_AUTUMN[3]])
                stamp(r.randrange(64), r.randrange(64), c, 2, 1)
    elif kind == 'forest':
        for i in range(34):
            c = r.choice([DEAD_LEAF[2], DEAD_LEAF[1], FERN[1]]) if season != 'autumn' else r.choice([DEAD_LEAF[3], RED_AUTUMN[2], GOLD_AUTUMN[2]])
            if season == 'winter':
                c = r.choice([hx('#7a6a58'), hx('#5c4c3c')])
            stamp(r.randrange(64), r.randrange(64), c, 2, 1)
        for i in range(8):
            stamp(r.randrange(64), r.randrange(64), hx('#5a4a38'), 3, 1)
    elif kind == 'dirt':
        for i in range(36):
            c = ROCK_W[r.randrange(1, 4)] if season != 'winter' else SNOW[3]
            stamp(r.randrange(64), r.randrange(64), c, 2, 1)
        for i in range(10):
            stamp(r.randrange(64), r.randrange(64), P[0], 3, 1)
    elif kind == 'moss':
        for i in range(40):
            stamp(r.randrange(64), r.randrange(64), P[4], 1, 1)
        for i in range(8):
            stamp(r.randrange(64), r.randrange(64), ROCK_W[2], 2, 2)
    return Image.fromarray(arr, 'RGBA')


# ----------------------------------------------------------------------------- registry
def static(fn, *a):
    return lambda: [fn(*a)]


def anim(fn, *a):
    return lambda: [fn(*a, t=t) if False else fn(a[0], t, *a[1:]) for t in range(NF)]


def items():
    out = []
    for s in SEASONS:
        out += [
            dict(id='plant_grass_%s' % s, category='plants', season=s, frames=lambda s=s: [plant_grass(s, t) for t in range(NF)], fps=8),
            dict(id='plant_tallgrass_%s' % s, category='plants', season=s, frames=lambda s=s: [plant_grass(s, t, True) for t in range(NF)], fps=8),
            dict(id='plant_fern_%s' % s, category='plants', season=s, frames=lambda s=s: [plant_fern(s, t) for t in range(NF)], fps=8),
            dict(id='plant_flowers_pink_%s' % s, category='plants', season=s, frames=lambda s=s: [plant_flowers(s, t, 'pink') for t in range(NF)], fps=8),
            dict(id='plant_flowers_yellow_%s' % s, category='plants', season=s, frames=lambda s=s: [plant_flowers(s, t, 'yellow') for t in range(NF)], fps=8),
            dict(id='plant_flowers_blue_%s' % s, category='plants', season=s, frames=lambda s=s: [plant_flowers(s, t, 'blue') for t in range(NF)], fps=8),
            dict(id='plant_reeds_%s' % s, category='plants', season=s, frames=lambda s=s: [plant_reeds(s, t) for t in range(NF)], fps=8),
            dict(id='plant_clover_%s' % s, category='plants', season=s, frames=lambda s=s: [plant_clover(s, 0)], fps=1),
            dict(id='plant_moss_%s' % s, category='plants', season=s, frames=lambda s=s: [plant_moss(s, 0)], fps=1),
            dict(id='plant_leaflitter_%s' % s, category='plants', season=s, frames=lambda s=s: [plant_leaflitter(s, 0)], fps=1),
            dict(id='mushroom_red_%s' % s, category='mushrooms', season=s, frames=lambda s=s: [plant_mushrooms(s, 0, 'red')], fps=1),
            dict(id='mushroom_brown_%s' % s, category='mushrooms', season=s, frames=lambda s=s: [plant_mushrooms(s, 0, 'brown')], fps=1),
            dict(id='mushroom_orange_%s' % s, category='mushrooms', season=s, frames=lambda s=s: [plant_mushrooms(s, 0, 'orange')], fps=1),
            dict(id='stump_plain_%s' % s, category='stumps_logs', season=s, frames=lambda s=s: [stump(s)], fps=1),
            dict(id='stump_tall_%s' % s, category='stumps_logs', season=s, frames=lambda s=s: [stump(s, tall=True)], fps=1),
            dict(id='stump_mossy_%s' % s, category='stumps_logs', season=s, frames=lambda s=s: [stump(s, mossy=True)], fps=1),
            dict(id='stump_axe_%s' % s, category='stumps_logs', season=s, frames=lambda s=s: [stump(s, axe=True)], fps=1),
        ]
        for k in ('single', 'mossy', 'hollow', 'branch_log', 'vertical'):
            out.append(dict(id='log_%s_%s' % (k, s), category='stumps_logs', season=s, frames=lambda s=s, k=k: [log(s, 0, k)], fps=1))
        out.append(dict(id='log_pile_%s' % s, category='stumps_logs', season=s, frames=lambda s=s: [log_pile(s)], fps=1))
        out.append(dict(id='firewood_bundle_%s' % s, category='stumps_logs', season=s, frames=lambda s=s: [firewood(s)], fps=1))
        for k in ('fork', 'twigs', 'big'):
            out.append(dict(id='branch_%s_%s' % (k, s), category='branches', season=s, frames=lambda s=s, k=k: [branches(s, 0, k)], fps=1))
        for k in ('pebbles', 'small', 'medium', 'boulder', 'slab', 'mossy', 'mossyb', 'cairn'):
            nm = {'mossyb': 'boulder_mossy'}.get(k, k if k in ('pebbles',) else 'rock_' + k)
            nm = 'rock_pebbles' if k == 'pebbles' else 'rock_boulder_mossy' if k == 'mossyb' else 'rock_' + k
            out.append(dict(id='%s_%s' % (nm, s), category='rocks', season=s, frames=lambda s=s, k=k: [rock(s, 0, k)], fps=1))
        for n in ('apple', 'orange', 'mulberry'):
            out.append(dict(id='fallen_%s_%s' % (n, s), category='fruit_decals', season=s, frames=lambda s=s, n=n: [fallen_fruit(s, 0, n)], fps=1))
        for c in ('apples', 'oranges', 'berries'):
            out.append(dict(id='basket_%s_%s' % (c, s), category='fruit_decals', season=s, frames=lambda s=s, c=c: [basket(s, 0, c)], fps=1))
        for k in ('grass', 'forest', 'dirt', 'moss'):
            out.append(dict(id='tile_%s_%s' % (k, s), category='ground_tiles', season=s, frames=lambda s=s, k=k: [tile(s, k)], fps=1))
    return out


if __name__ == '__main__':
    BG = {'spring': hx('#86b85c'), 'summer': hx('#68a048'), 'autumn': hx('#a09444'), 'winter': hx('#dce8f2')}
    its = items()
    from collections import OrderedDict
    groups = OrderedDict()
    for it in its:
        if it['category'] == 'ground_tiles':
            continue
        key = it['id'].rsplit('_', 1)[0]
        groups.setdefault(key, {})[it['season']] = it
    sc = 1
    cols = 16
    keys = list(groups)
    rows = (len(keys) * 4 + cols - 1) // cols
    # one image: each row = one asset, 4 seasons
    per_row = 4
    cellw = 64
    im = Image.new('RGBA', (cellw * 4 * 4, 64 * ((len(keys) + 3) // 4)), (0, 0, 0, 255))
    for k, key in enumerate(keys):
        for si, s in enumerate(SEASONS):
            it = groups[key][s]
            fr = it['frames']()[0]
            tile_ = Image.new('RGBA', (64, 64), BG[s] + (255,))
            tile_.alpha_composite(fr)
            im.paste(tile_, (((k % 4) * 4 + si) * 64, (k // 4) * 64))
    im = im.resize((im.width * 1, im.height * 1), Image.NEAREST)
    n = len(keys)
    half = (n + 1) // 2
    for idx, (a, b) in enumerate([(i, min(i + 24, n)) for i in range(0, n, 24)]):
        sub = Image.new('RGBA', (64 * 16, 64 * ((b - a + 3) // 4)), (0, 0, 0, 255))
        for k, key in enumerate(keys[a:b]):
            for si, s in enumerate(SEASONS):
                tile_ = Image.new('RGBA', (64, 64), BG[s] + (255,))
                tile_.alpha_composite(groups[key][s]['frames']()[0])
                sub.paste(tile_, (((k % 4) * 4 + si) * 64, (k // 4) * 64))
        sub.convert('RGB').save('/tmp/fb_%d.png' % idx)
    print(n, 'groups', len(its), 'items')
    ti = Image.new('RGB', (64 * 4 * 2, 64 * 4 * 2))
    for ki, k in enumerate(('grass', 'forest', 'dirt', 'moss')):
        for si, s in enumerate(SEASONS):
            t2 = tile(s, k).convert('RGB')
            ti.paste(t2, (si * 64, ki * 64))
    ti.save('/tmp/fb_tiles.png')
