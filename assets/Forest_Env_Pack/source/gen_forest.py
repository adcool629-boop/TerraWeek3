# -*- coding: utf-8 -*-
"""gen_forest.py - builds the full Forest Environment pack (frames, sheets, atlas, previews, palette)."""
import os, sys, json, shutil
sys.path.insert(0, os.path.dirname(os.path.abspath(__file__)))
from PIL import Image
import numpy as np
import forest_a, forest_b
from gen_trees import hx

OUT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))
SEASONS = ['spring', 'summer', 'autumn', 'winter']
BG = {'spring': '#86b85c', 'summer': '#68a048', 'autumn': '#a09444', 'winter': '#dce8f2'}
CATS = ['fruit_trees', 'berry_bushes', 'bushes', 'plants', 'mushrooms', 'stumps_logs', 'branches', 'rocks', 'fruit_decals', 'ground_tiles']


def main():
    for d in ('frames', 'sheets', 'atlas', 'preview', 'palette'):
        shutil.rmtree(os.path.join(OUT, d), ignore_errors=True)
        os.makedirs(os.path.join(OUT, d))
    its = forest_a.items() + forest_b.items()
    data = {}
    for it in its:
        fr = it['frames']()
        data[it['id']] = (it, fr)
        cat = it['category']
        os.makedirs(os.path.join(OUT, 'frames', cat, it['id']), exist_ok=True)
        os.makedirs(os.path.join(OUT, 'sheets', cat), exist_ok=True)
        for i, f in enumerate(fr):
            f.save(os.path.join(OUT, 'frames', cat, it['id'], '%s_%02d.png' % (it['id'], i)))
        sh = Image.new('RGBA', (64 * len(fr), 64), (0, 0, 0, 0))
        for i, f in enumerate(fr):
            sh.paste(f, (64 * i, 0))
        sh.save(os.path.join(OUT, 'sheets', cat, it['id'] + '.png'))
    # atlas
    cols = 16
    total = sum(len(f) for _, f in data.values())
    rows = (total + cols - 1) // cols
    atlas = Image.new('RGBA', (cols * 64, rows * 64), (0, 0, 0, 0))
    meta = {'tile': 64, 'pivot': {'x': 0.5, 'y': 0.906}, 'items': {}}
    k = 0
    for iid, (it, fr) in data.items():
        rects = []
        for f in fr:
            x, y = (k % cols) * 64, (k // cols) * 64
            atlas.paste(f, (x, y))
            rects.append({'x': x, 'y': y, 'w': 64, 'h': 64})
            k += 1
        meta['items'][iid] = {'category': it['category'], 'season': it['season'], 'state': it.get('state', ''),
                              'fps': it['fps'], 'loop': len(fr) > 1, 'frames': rects}
    atlas.save(os.path.join(OUT, 'atlas', 'forest_atlas.png'))
    json.dump(meta, open(os.path.join(OUT, 'atlas', 'forest_atlas.json'), 'w'), indent=1)
    # previews per category: row per asset, 4 seasons (first frame), 2x
    sc = 2
    for cat in CATS:
        ids = [i for i, (it, _) in data.items() if it['category'] == cat]
        if cat == 'fruit_trees' or cat == 'berry_bushes':
            keys = sorted({i.rsplit('_', 2)[0] + '|' + i.rsplit('_', 1)[1] for i in ids}) if False else None
        # group by (base, state) -> seasons
        groups = {}
        for i in ids:
            it, fr = data[i]
            base = i[:-(len(it['season']) + 1)] if not it.get('state') else i[:-(len(it['season']) + 1 + len(it['state']) + 1)] + ('_' + it['state'])
            if it.get('state'):
                base = i.replace('_' + it['season'] + '_' + it['state'], '') + '_' + it['state']
            groups.setdefault(base, {})[it['season']] = fr
        keys = list(groups)
        per = 4 if cat != 'ground_tiles' else 4
        rws = (len(keys) + per - 1) // per
        pw = 64 * sc
        im = Image.new('RGB', (per * 4 * pw, rws * pw), (20, 20, 24))
        for ki, key in enumerate(keys):
            for si, s in enumerate(SEASONS):
                t = Image.new('RGBA', (64, 64), hx(BG[s]) + (255,))
                t.alpha_composite(groups[key][s][0])
                im.paste(t.resize((pw, pw), Image.NEAREST).convert('RGB'), (((ki % per) * 4 + si) * pw, (ki // per) * pw))
        im.save(os.path.join(OUT, 'preview', 'overview_%s.png' % cat))
    # gifs: sway for hero items
    def gif(ids, name, scale=3):
        frs = []
        for t in range(8):
            row = Image.new('RGB', (64 * len(ids) * scale, 64 * scale))
            for j, i in enumerate(ids):
                it, fr = data[i]
                s = it['season']
                tl = Image.new('RGBA', (64, 64), hx(BG[s]) + (255,))
                tl.alpha_composite(fr[t % len(fr)])
                row.paste(tl.resize((64 * scale, 64 * scale), Image.NEAREST).convert('RGB'), (j * 64 * scale, 0))
            frs.append(row)
        frs[0].save(os.path.join(OUT, 'preview', name), save_all=True, append_images=frs[1:], duration=150, loop=0)
    for n in ('apple', 'orange', 'mulberry'):
        gif(['tree_%s_%s_fruit' % (n, s) for s in SEASONS], 'sway_tree_%s.gif' % n)
    gif(['bush_blueberry_%s_fruit' % s for s in SEASONS], 'sway_bush_blueberry.gif')
    gif(['plant_fern_%s' % s for s in SEASONS], 'sway_fern.gif')
    # fruit vs picked comparison
    pw = 128
    im = Image.new('RGB', (8 * pw, 3 * pw))
    for r_, n in enumerate(('apple', 'orange', 'mulberry')):
        for si, s in enumerate(SEASONS):
            for sj, st in enumerate(('fruit', 'picked')):
                t = Image.new('RGBA', (64, 64), hx(BG[s]) + (255,))
                t.alpha_composite(data['tree_%s_%s_%s' % (n, s, st)][1][0])
                im.paste(t.resize((pw, pw), Image.NEAREST).convert('RGB'), ((si * 2 + sj) * pw, r_ * pw))
    im.save(os.path.join(OUT, 'preview', 'fruit_vs_picked.png'))
    # scene
    import random
    r = random.Random(7)
    for s in SEASONS:
        W = 20
        scene = Image.new('RGBA', (W * 64, 8 * 64), (0, 0, 0, 255))
        tl = data['tile_grass_%s' % s][1][0]
        for y in range(8):
            for x in range(W):
                scene.paste(tl, (x * 64, y * 64))
        pool = [i for i, (it, _) in data.items() if it['season'] == s and it['category'] in ('fruit_trees', 'bushes', 'berry_bushes', 'plants', 'mushrooms', 'stumps_logs', 'branches', 'rocks')]
        spots = sorted([(r.randrange(0, W * 64 - 64), r.randrange(0, 8 * 64 - 64)) for _ in range(46)], key=lambda p: p[1])
        for (x, y) in spots:
            scene.alpha_composite(data[r.choice(pool)][1][0], (x, y))
        scene.convert('RGB').save(os.path.join(OUT, 'preview', 'scene_%s.png' % s))
    # palette
    cols = set()
    for iid, (it, fr) in data.items():
        if it['category'] == 'ground_tiles':
            continue
        for f in fr[:1]:
            a = np.array(f)
            m = a[..., 3] == 255
            for c in np.unique(a[m][:, :3], axis=0):
                cols.add(tuple(int(v) for v in c))
    cols = sorted(cols, key=lambda c: (sum(c)))
    open(os.path.join(OUT, 'palette', 'palette.hex'), 'w').write('\n'.join('%02x%02x%02x' % c for c in cols))
    n = len(cols)
    pc = Image.new('RGB', (min(n, 32) * 8, ((n + 31) // 32) * 8))
    for i, c in enumerate(cols):
        pc.paste(c, ((i % 32) * 8, (i // 32) * 8, (i % 32) * 8 + 8, (i // 32) * 8 + 8))
    pc.save(os.path.join(OUT, 'palette', 'palette.png'))
    cnt = {c: sum(1 for i, (it, _) in data.items() if it['category'] == c) for c in CATS}
    print(len(data), 'sprites', total, 'frames', len(cols), 'colors', cnt)


if __name__ == '__main__':
    main()
