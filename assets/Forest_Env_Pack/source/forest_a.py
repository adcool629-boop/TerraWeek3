# -*- coding: utf-8 -*-
"""forest_a.py - fruit trees (apple / orange / mulberry) and bushes (incl. berry bushes), 4 seasons x fruit/picked."""
import sys, os, math, random
sys.path.insert(0, '/home/claude/TopDown_Trees_Seasons_Pack/source')
import numpy as np
import gen_trees as G
from gen_trees import (Canvas, Blob, draw_blob, draw_trunk, Skeleton, draw_skeleton, trunk_x, sway, draw_shadow,
                       draw_snow_ground, draw_snow_mound, hrand, bay, hx, pal, mix, clamp, seed_of,
                       NF, BASE_X, BASE_Y, LEAF, TRUNK, BRANCH, SNOWL, SHADOW)

SEASONS = ['spring', 'summer', 'autumn', 'winter']

# ----------------------------------------------------------------------------- palettes
FR = dict(
    apple_red=pal('#5a1010', '#8c1c1c', '#d03030', '#ff8a78'),
    apple_green=pal('#2a4a10', '#4a7c20', '#8cb83c', '#d0f080'),
    apple_yellow=pal('#6a4a10', '#b08a20', '#e8c040', '#fff0a0'),
    apple_dried=pal('#2a1010', '#4a2020', '#6a2c28', '#8c4a40'),
    orange=pal('#6a2e08', '#b85a10', '#f09a28', '#ffd070'),
    orange_green=pal('#2a4a10', '#5a8a20', '#9cc840', '#d8f080'),
    orange_mix=pal('#5a4010', '#c88a18', '#e8b830', '#fff090'),
    mulb_red=pal('#4a0c20', '#8c1c3c', '#d03058', '#ff8aa8'),
    mulb_dark=pal('#1a0828', '#3c1858', '#6a2c8c', '#a868d0'),
    mulb_green=pal('#2a4a10', '#5a8a20', '#a8d850', '#e0ff9c'),
    mulb_dried=pal('#1a1018', '#3a2030', '#5a3448', '#7a5468'),
    blue=pal('#101a40', '#24388c', '#4468d0', '#9ab4ff'),
    rasp=pal('#4a0a1c', '#a01838', '#e03858', '#ff9ab0'),
    black=pal('#10081a', '#2a1840', '#4a2c68', '#8a68b0'),
    holly=pal('#4a0c10', '#9a1c20', '#e03030', '#ff9a88'),
)

LEAF_P = {
    'apple': pal('#1a4226', '#286632', '#428e3c', '#6ab44a', '#a0d468'),
    'orange': pal('#0e3018', '#1a5428', '#2a7a34', '#44a044', '#76c85c'),
    'mulberry': pal('#244a1c', '#3c7428', '#5c9c34', '#88c448', '#b8e468'),
    'bush': pal('#18402a', '#24683a', '#38904a', '#5cb45a', '#92d874'),
    'holly': pal('#0c2c20', '#164a30', '#226a40', '#368a54', '#5aac70'),
    'berry': pal('#1c4426', '#2c6c34', '#44923c', '#6cb84c', '#a0dc6c'),
    'bushfl': pal('#1e4a2c', '#2e723c', '#46984c', '#6cbc5c', '#a0de78'),
}
GOLD_AUTUMN = pal('#604618', '#a07824', '#d4aa34', '#f0d054', '#fcec8c')
RED_AUTUMN = pal('#54161a', '#8c2220', '#c43828', '#e46030', '#f69648')
WHITE_BL = pal('#6e4a60', '#be8ca4', '#ecc4d2', '#fce4ec', '#fff8fa')
WHITE_BL2 = pal('#7a6a50', '#d8cdb0', '#f2ecd8', '#fffaf0', '#ffffff')
PINK_BL = G.BLOSSOM_PINK
TWIG = pal('#2a1c14', '#4a3424', '#6c4e36', '#8e7050', '#b09470')


def spring(p):
    return G.spring_of(p)


# ----------------------------------------------------------------------------- tree specs
CROWN = {
    'apple': [(32, 16, 10, 9), (22, 22, 9, 8), (42, 22, 9, 8), (15, 31, 7, 6), (49, 31, 7, 6), (26, 33, 9, 7),
              (38, 33, 9, 7), (32, 26, 11, 9), (32, 39, 9, 5)],
    'orange': [(32, 15, 11, 9), (21, 21, 10, 8), (43, 21, 10, 8), (14, 31, 8, 7), (50, 31, 8, 7), (23, 33, 10, 8),
               (41, 33, 10, 8), (32, 26, 13, 10), (32, 40, 11, 6)],
    'mulberry': [(32, 17, 9, 8), (20, 20, 10, 8), (44, 20, 10, 8), (11, 29, 8, 7), (53, 29, 8, 7), (26, 28, 11, 9),
                 (38, 28, 11, 9), (32, 22, 10, 8), (18, 38, 8, 5), (46, 38, 8, 5), (32, 38, 12, 6)],
}
TRUNK_SPEC = {
    'apple': dict(w_base=7, w_top=5, fork_y=34, lean=1, wob=1.0, pal=G.TRUNKS['apple']),
    'orange': dict(w_base=7, w_top=5, fork_y=36, lean=0, wob=0.6, pal=pal('#2c1c14', '#4c3220', '#745032', '#9a7448', '#c09a68')),
    'mulberry': dict(w_base=8, w_top=6, fork_y=32, lean=-2, wob=1.2, pal=pal('#2a2218', '#4a3e2e', '#6c5a42', '#8e7a5c', '#b09c7c')),
}
SKEL_SPEC = {'apple': (3, 2.2, 10, 3), 'mulberry': (4, 2.6, 11, 3)}
SWAYA = {'apple': 1.2, 'orange': 1.0, 'mulberry': 1.4}
BARE_WINTER = {'apple', 'mulberry'}


def foliage_pals(name, season, state):
    """list of (palette, weight)"""
    base = LEAF_P[name]
    if name == 'apple':
        return {'spring': [(WHITE_BL, 0.72), (spring(base), 0.28)] if state == 'fruit' else [(spring(base), 1.0)],
                'summer': [(base, 1.0)],
                'autumn': G.AUTUMN['apple'],
                'winter': [(base, 1.0)]}[season]
    if name == 'orange':
        return {'spring': [(WHITE_BL2, 0.45), (base, 0.55)] if state == 'fruit' else [(spring(base), 0.5), (base, 0.5)],
                'summer': [(base, 1.0)],
                'autumn': [(base, 0.8), (pal('#304a1c', '#506e28', '#6c8c34', '#8aac44', '#b0cc60'), 0.2)],
                'winter': [(pal('#12301c', '#1e4a2c', '#2e6a3a', '#468a50', '#70ac70'), 1.0)]}[season]
    return {'spring': [(spring(base), 1.0)], 'summer': [(base, 1.0)],
            'autumn': [(GOLD_AUTUMN, 0.8), (pal('#5a4a18', '#98801e', '#c8a82c', '#e8cc4c', '#f8e888'), 0.2)],
            'winter': [(base, 1.0)]}[season]


# fruit recipe: (list of (palette, weight), count, size)   size 4 = apple/orange, 3 small, 2 berry
def fruit_recipe(name, season, state):
    if state == 'picked':
        return None
    if name == 'apple':
        return {'spring': None,
                'summer': ([(FR['apple_red'], 0.5), (FR['apple_green'], 0.3), (FR['apple_yellow'], 0.2)], 14, 4),
                'autumn': ([(FR['apple_red'], 0.7), (FR['apple_yellow'], 0.3)], 18, 4),
                'winter': ([(FR['apple_dried'], 1.0)], 4, 4)}[season]
    if name == 'orange':
        return {'spring': ([(FR['orange_green'], 1.0)], 6, 3),
                'summer': ([(FR['orange_green'], 0.8), (FR['orange_mix'], 0.2)], 14, 4),
                'autumn': ([(FR['orange_mix'], 0.5), (FR['orange'], 0.35), (FR['orange_green'], 0.15)], 15, 4),
                'winter': ([(FR['orange'], 1.0)], 18, 4)}[season]
    return {'spring': ([(FR['mulb_green'], 1.0)], 12, 2),
            'summer': ([(FR['mulb_red'], 0.5), (FR['mulb_dark'], 0.5)], 30, 2),
            'autumn': ([(FR['mulb_dark'], 1.0)], 9, 2),
            'winter': ([(FR['mulb_dried'], 1.0)], 4, 2)}[season]


SHAPE4 = ['.HM.', 'HMMD', 'MMDD', '.DD.']
SHAPE3 = ['HM.', 'MMD', '.DD']
SHAPE2 = ['HM', 'DD']


def draw_fruit(S, x, y, p, size):
    shape = {4: SHAPE4, 3: SHAPE3, 2: SHAPE2}[size]
    cm = {'H': p[3], 'M': p[2], 'D': p[1]}
    cells = {}
    for j, row in enumerate(shape):
        for i, ch in enumerate(row):
            if ch != '.':
                cells[(x + i, y + j)] = cm[ch]
    if size >= 3:
        for (cx, cy) in list(cells):
            for dx, dy in ((1, 0), (-1, 0), (0, 1), (0, -1)):
                q = (cx + dx, cy + dy)
                if q not in cells:
                    S.put(q[0], q[1], p[0], LEAF, p[0])
    for (cx, cy), c in cells.items():
        S.put(cx, cy, c, LEAF, p[0])


def place_fruit(name, season, state, blobs, tips=None):
    """returns list of (parent_index or None, dx, dy, palette, size)"""
    rec = fruit_recipe(name, season, state)
    if rec is None:
        return []
    pl, n, size = rec
    r = random.Random(seed_of('fruit' + name + season))
    out = []
    if tips is not None:
        pts = list(tips)
        r.shuffle(pts)
        for (x, y) in pts[:n]:
            pick = r.choices([q for q, w in pl], [w for q, w in pl])[0]
            out.append((None, int(x), int(y) + 1, pick, size))
        return out
    areas = [b.rx * b.ry for b in blobs]
    tot = float(sum(areas))
    for _ in range(n):
        bi = r.choices(range(len(blobs)), areas)[0]
        b = blobs[bi]
        for _try in range(8):
            a = r.uniform(0.2, math.pi - 0.2)          # lower half preferred
            rr = math.sqrt(r.uniform(0.12, 0.72))
            dx = int(math.cos(a) * rr * b.rx * (1 if r.random() < 0.5 else -1))
            dy = int(math.sin(a) * rr * b.ry) - 1
            if abs(dx) < b.rx * 0.9:
                break
        pick = r.choices([q for q, w in pl], [w for q, w in pl])[0]
        out.append((bi, dx, dy, pick, size))
    return out


def make_blobs(name, season, state):
    seed0 = seed_of(name + season)
    r = random.Random(seed0)
    pl = foliage_pals(name, season, state)
    blobs = []
    snow = 0.55 if (season == 'winter' and name == 'orange') else 0.0
    for i, (cx, cy, rx, ry) in enumerate(CROWN[name]):
        p = r.choices([q for q, w in pl], [w for q, w in pl])[0]
        blobs.append(Blob(cx, cy, rx, ry, p, seed0 + i, snow=snow, speck_n=None))
    return blobs


_BL = {}


def render_tree(name, season, state, t):
    S = Canvas()
    A = SWAYA[name]
    tr = dict(TRUNK_SPEC[name])
    if season == 'winter':
        draw_snow_ground(S)
    else:
        draw_shadow(S)
    draw_trunk(S, tr, name)
    if season == 'winter':
        draw_snow_mound(S)
    bare = (season == 'winter' and name in BARE_WINTER)
    key = (name, season, state)
    if key not in _BL:
        blobs = [] if bare else make_blobs(name, season, state)
        tips = None
        _BL[key] = blobs
    blobs = _BL[key]
    if bare:
        n, sp, L0, dm = SKEL_SPEC[name]
        sk = Skeleton(trunk_x(tr, 1.0), tr['fork_y'], n, sp, L0, dm, seed_of(name + 'skel'))
        pts = draw_skeleton(S, sk, t, A, TWIG if False else tr['pal'], snow=True, name=name)
        tips = [(pts[b][0], pts[b][1]) for (a, b, d) in sk.segs if d >= 2]
        fr = place_fruit(name, season, state, [], tips=tips)
        for (_, x, y, p, size) in fr:
            draw_fruit(S, x, y, p, size)
        S.outline()
        return S.image()
    order = sorted(range(len(blobs)), key=lambda i: (blobs[i].cy, blobs[i].cx))
    offs = {}
    for i in order:
        b = blobs[i]
        ox, oy = sway(t, b.cx, b.cy, A)
        offs[i] = (ox, oy)
        draw_blob(S, b, ox, oy, t)
    fkey = ('fr',) + key
    if fkey not in _BL:
        _BL[fkey] = place_fruit(name, season, state, blobs)
    for (bi, dx, dy, p, size) in _BL[fkey]:
        b = blobs[bi]
        ox, oy = offs[bi]
        draw_fruit(S, int(b.cx + ox + dx), int(b.cy + oy + dy), p, size)
    S.outline()
    return S.image()


# ----------------------------------------------------------------------------- bushes
BUSH_SHAPES = {
    'round': [(32, 45, 13, 9), (21, 48, 9, 7), (43, 48, 9, 7), (32, 39, 10, 8), (26, 42, 8, 6), (38, 42, 8, 6)],
    'tall': [(32, 44, 11, 10), (26, 35, 9, 9), (38, 35, 9, 9), (32, 27, 8, 8), (22, 47, 8, 6), (42, 47, 8, 6)],
    'flower': [(32, 45, 14, 9), (20, 47, 9, 7), (44, 47, 9, 7), (32, 38, 11, 8), (24, 41, 8, 6), (40, 41, 8, 6)],
    'holly': [(32, 44, 12, 10), (24, 38, 9, 8), (40, 38, 9, 8), (32, 33, 8, 7), (22, 47, 8, 6), (42, 47, 8, 6)],
    'blueberry': [(32, 45, 12, 8), (23, 47, 8, 6), (41, 47, 8, 6), (32, 39, 9, 7), (27, 42, 7, 5), (37, 42, 7, 5)],
    'raspberry': [(32, 40, 9, 12), (24, 44, 7, 9), (40, 44, 7, 9), (32, 30, 7, 8), (28, 47, 6, 5), (36, 47, 6, 5)],
    'blackberry': [(32, 44, 13, 9), (19, 46, 8, 7), (45, 46, 8, 7), (32, 37, 11, 8), (25, 41, 8, 6), (39, 41, 8, 6), (32, 49, 10, 5)],
}
BUSH_BASE = {'round': 'bush', 'tall': 'bush', 'flower': 'bushfl', 'holly': 'holly', 'blueberry': 'berry', 'raspberry': 'berry',
             'blackberry': 'berry'}
BERRY_FR = {'blueberry': 'blue', 'raspberry': 'rasp', 'blackberry': 'black'}
BUSH_SKEL = {'round': (6, 3.0, 10, 3), 'tall': (6, 2.0, 15, 3), 'flower': (6, 3.0, 10, 3), 'holly': (6, 2.2, 12, 3),
             'blueberry': (6, 3.0, 10, 3), 'raspberry': (5, 1.8, 17, 3), 'blackberry': (7, 3.2, 10, 3)}


def bush_pal(kind, season):
    base = LEAF_P[BUSH_BASE[kind]]
    if kind == 'holly':
        return [(base, 1.0)]
    if season == 'spring':
        return [(spring(base), 1.0)]
    if season == 'summer':
        return [(base, 1.0)]
    if season == 'autumn':
        if kind == 'flower':
            return [(RED_AUTUMN, 0.6), (GOLD_AUTUMN, 0.4)]
        if kind in ('blueberry', 'raspberry', 'blackberry'):
            return [(RED_AUTUMN, 0.55), (GOLD_AUTUMN, 0.3), (base, 0.15)]
        return [(pal('#5a4a14', '#98801c', '#c8a82a', '#e6cc48', '#f8e884'), 0.6), (base, 0.4)]
    return [(base, 1.0)]


def bush_flowers(kind, season, S_dots=None):
    """flower dots for spring/summer bushes (list of palettes)"""
    return None


def render_bush(kind, season, state, t):
    S = Canvas()
    A = 1.0
    if season == 'winter':
        draw_snow_ground(S)
    else:
        draw_shadow(S)
    seed0 = seed_of('bush' + kind + season)
    r = random.Random(seed0)
    berry = kind in BERRY_FR
    bare = (season == 'winter' and kind != 'holly')
    if bare:
        n, sp, L0, dm = BUSH_SKEL[kind]
        sk = Skeleton(32, 56, n, sp, L0, dm, seed_of(kind + 'skel'))
        pts = draw_skeleton(S, sk, t, A * 0.8, TWIG, snow=True, name=kind)
        if berry and state == 'fruit':
            tips = [(pts[b][0], pts[b][1]) for (a, b, d) in sk.segs if d >= 2]
            r.shuffle(tips)
            for (x, y) in tips[:4]:
                draw_fruit(S, int(x), int(y), FR['mulb_dried'], 2)
        S.outline()
        return S.image()
    pl = bush_pal(kind, season)
    snow = 0.55 if (season == 'winter' and kind == 'holly') else 0.0
    blobs = []
    for i, (cx, cy, rx, ry) in enumerate(BUSH_SHAPES[kind]):
        p = r.choices([q for q, w in pl], [w for q, w in pl])[0]
        blobs.append(Blob(cx, cy, rx, ry, p, seed0 + i, snow=snow))
    order = sorted(range(len(blobs)), key=lambda i: (blobs[i].cy, blobs[i].cx))
    offs = {}
    for i in order:
        b = blobs[i]
        ox, oy = sway(t, b.cx, b.cy + 14, A)
        offs[i] = (ox, oy)
        draw_blob(S, b, ox, oy, t)
    # decorations: berries / flowers
    deco = []
    rr = random.Random(seed0 + 99)

    def scatter(n, palettes, size, lower=True):
        for _ in range(n):
            bi = rr.randrange(len(blobs))
            b = blobs[bi]
            a = rr.uniform(0.15, math.pi - 0.15) if lower else rr.uniform(0, 2 * math.pi)
            q = math.sqrt(rr.uniform(0.1, 0.7))
            dx = int(math.cos(a) * q * b.rx * (1 if rr.random() < 0.5 else -1))
            dy = int(math.sin(a) * q * b.ry) - 1
            deco.append((bi, dx, dy, rr.choice(palettes), size))

    if berry:
        fp = FR[BERRY_FR[kind]]
        if state == 'fruit':
            if season == 'spring':
                scatter(9, [WHITE_BL2], 2, False)
            elif season == 'summer':
                scatter(26, [fp], 2)
            elif season == 'autumn':
                scatter(7, [fp], 2)
        else:
            if season == 'spring':
                scatter(7, [WHITE_BL2], 2, False)
    elif kind == 'flower':
        if season == 'spring':
            scatter(22, [PINK_BL, WHITE_BL], 2, False)
        elif season == 'summer':
            scatter(12, [pal('#7a1c3c', '#c43c74', '#ec6aa0', '#ffb0d0')], 2, False)
    elif kind == 'holly':
        if season == 'winter' or season == 'autumn':
            scatter(14, [FR['holly']], 2, False)
    for (bi, dx, dy, p, size) in deco:
        b = blobs[bi]
        ox, oy = offs[bi]
        if size == 2:
            x, y = int(b.cx + ox + dx), int(b.cy + oy + dy)
            S.put(x, y, p[3], LEAF, p[0])
            S.put(x + 1, y, p[2], LEAF, p[0])
            S.put(x, y + 1, p[1], LEAF, p[0])
            S.put(x + 1, y + 1, p[1], LEAF, p[0])
    S.outline()
    return S.image()


# ----------------------------------------------------------------------------- registry
TREE_NAMES = ['apple', 'orange', 'mulberry']
BUSH_NAMES = ['round', 'tall', 'flower', 'holly']
BERRY_NAMES = ['blueberry', 'raspberry', 'blackberry']


def items():
    out = []
    for n in TREE_NAMES:
        for s in SEASONS:
            for st in ('fruit', 'picked'):
                out.append(dict(id='tree_%s_%s_%s' % (n, s, st), category='fruit_trees', season=s, state=st,
                                frames=lambda n=n, s=s, st=st: [render_tree(n, s, st, t) for t in range(NF)], fps=8))
    for n in BUSH_NAMES:
        for s in SEASONS:
            out.append(dict(id='bush_%s_%s' % (n, s), category='bushes', season=s, state='',
                            frames=lambda n=n, s=s: [render_bush(n, s, 'fruit', t) for t in range(NF)], fps=8))
    for n in BERRY_NAMES:
        for s in SEASONS:
            for st in ('fruit', 'picked'):
                out.append(dict(id='bush_%s_%s_%s' % (n, s, st), category='berry_bushes', season=s, state=st,
                                frames=lambda n=n, s=s, st=st: [render_bush(n, s, st, t) for t in range(NF)], fps=8))
    return out


if __name__ == '__main__':
    from PIL import Image
    BG = {'spring': hx('#86b85c'), 'summer': hx('#68a048'), 'autumn': hx('#a09444'), 'winter': hx('#dce8f2')}
    sc = 2
    rows = [(n, st) for n in TREE_NAMES for st in ('fruit', 'picked')]
    im = Image.new('RGBA', (64 * sc * 4, 64 * sc * len(rows)), (0, 0, 0, 255))
    for ri, (n, st) in enumerate(rows):
        for ci, s in enumerate(SEASONS):
            tile = Image.new('RGBA', (64, 64), BG[s] + (255,))
            tile.alpha_composite(render_tree(n, s, st, 0))
            im.paste(tile.resize((64 * sc, 64 * sc), Image.NEAREST), (ci * 64 * sc, ri * 64 * sc))
    im.convert('RGB').save('/tmp/fa_trees.png')
    rows = [('bush', k) for k in BUSH_NAMES] + [('berry', k) for k in BERRY_NAMES]
    im = Image.new('RGBA', (64 * sc * 8, 64 * sc * len(rows)), (0, 0, 0, 255))
    for ri, (_, k) in enumerate(rows):
        for ci, s in enumerate(SEASONS):
            for si, st in enumerate(('fruit', 'picked')):
                tile = Image.new('RGBA', (64, 64), BG[s] + (255,))
                tile.alpha_composite(render_bush(k, s, st, 0))
                im.paste(tile.resize((64 * sc, 64 * sc), Image.NEAREST), ((ci * 2 + si) * 64 * sc, ri * 64 * sc))
    im.convert('RGB').save('/tmp/fa_bushes.png')
    print('ok')
