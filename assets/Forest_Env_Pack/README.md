# حزمة بيئة الغابة 64×64 — Top-Down Forest Environment Pack

## بالعربية
- **244 عنصراً (888 إطاراً)**، كل عنصر بالفصول الأربعة (ربيع/صيف/خريف/شتاء)، بكسل 64×64، إضاءة من أعلى اليسار وظل أرضي.
- **أشجار الفاكهة** (تفاح، برتقال، توت): حالتان `fruit` (بالثمر) و`picked` (بعد القطف) × 4 فصول، مع تمايل 8 إطارات.
- **شجيرات**: 4 أنواع عادية، و3 شجيرات توت (أزرق، فرامبوز، عليق) بحالتي ثمر/مقطوف.
- **نباتات**: عشب، عشب طويل، سرخس، 3 أنواع زهور، قصب، برسيم، طحلب، أوراق متساقطة، و3 أنواع فطر.
- **جذوع وأخشاب**: جذع عادي/طويل/مطحلب/مع فأس، جذوع أفقية (عادية، مطحلبة، مجوفة، بفروع، عمودية)، كومة حطب، حزمة حطب.
- **أغصان**: متفرع، عيدان، غصن كبير. **أحجار**: حصى، صغير، متوسط، صخرة، لوح، مطحلب، صخرة مطحلبة، كومة حجارة.
- **ثمار ساقطة** وسلال حصاد (تفاح/برتقال/توت)، و**بلاطات أرض متكررة** (عشب، أرض غابة، تراب، طحلب) ×4 فصول.
- الأسماء: `tree_apple_summer_fruit`, `rock_boulder_autumn`, ...
- الملفات: `frames/` (إطارات PNG)، `sheets/` (شرائط أفقية)، `atlas/` (أطلس + JSON، نقطة الارتكاز 0.5, 0.906 = (32,58))، `preview/`، `palette/`، `source/` (المولّدات بـ Python).
- العناصر المتحركة 8 إطارات بسرعة 8 إطار/ث؛ الصخور والجذوع ثابتة.

## English
- **244 sprites (888 frames)**, each in 4 seasons, 64×64, top-left light, ground shadow.
- Fruit trees (apple / orange / mulberry) in `fruit` and `picked` states × 4 seasons, 8-frame sway.
- Bushes (4 types + blueberry/raspberry/blackberry with fruit/picked), plants, ferns, flowers, reeds, mushrooms.
- Stumps, logs, log pile, firewood, branches, rocks (pebbles → boulders, mossy, cairn), fallen fruit, baskets.
- 16 seamless 64×64 ground tiles (grass, forest floor, dirt, moss × 4 seasons).
- Folders: `frames/`, `sheets/`, `atlas/` (PNG+JSON, pivot 0.5/0.906), `preview/`, `palette/`, `source/` (Python generators; run `python3 source/gen_forest.py`; needs the tree pack's `gen_trees.py`).
