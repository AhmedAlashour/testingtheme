# ☕ Coffee Roastery — Salla Theme (Ready to Install)

## الملفات وأين تنسخها

```
📂 هذا الملف                    →  📂 انسخه هنا في مجلد الثيم
─────────────────────────────────────────────────────────────
twilight.json                   →  twilight.json (الجذر)
locales/ar.json                 →  src/locales/ar.json (ادمجه)
locales/en.json                 →  src/locales/en.json (ادمجه)
assets/styles/coffee-theme.css  →  src/assets/styles/coffee-theme.css
assets/js/coffee-theme.js       →  src/assets/js/coffee-theme.js
views/pages/index.twig          →  src/views/pages/index.twig (استبدله)
views/components/home/*.twig    →  src/views/components/home/ (كل الملفات)
```

## خطوات سريعة

### 1. أنشئ الثيم
```bash
npm install -g @salla/cli
salla login
salla theme create
cd my-coffee-theme
```

### 2. انسخ الملفات
انسخ كل ملفات هذا المجلد إلى الأماكن المحددة أعلاه.

### 3. اربط الستايل والجافاسكربت
أضف هذا السطر في نهاية `src/assets/styles/app.scss`:
```scss
@import './coffee-theme.css';
```

أضف هذا السطر في نهاية `src/assets/js/app.js`:
```javascript
import './coffee-theme.js';
```

### 4. ادمج ملفات الترجمة
افتح `src/locales/ar.json` الموجود وأضف محتوى `ar.json` الجديد بداخله.
نفس الشيء مع `en.json`.

### 5. شغّل المعاينة
```bash
salla theme preview
```

### 6. خصّص من لوحة سلة
بعد التثبيت، اذهب إلى لوحة تحكم متجرك → الثيمات → تخصيص:
- **رابط فيديو الهيرو** — ارفع فيديو MP4 وضع الرابط
- **عنوان الهيرو** — غيّر النص الرئيسي
- **رقم الواتساب** — مثال: 966501234567
- **سعر الاشتراك** — السعر الشهري

### 7. انشر
```bash
git add .
git commit -m "coffee theme ready"
git push origin main
salla theme publish
```

## ما الذي تغيّر عن الملفات القديمة؟

| قبل (قديم) | بعد (جاهز لسلة) |
|------------|-----------------|
| نصوص ثابتة بالعربي | `trans()` ترجمة عربي + إنجليزي |
| منتجات ثابتة (placeholder) | `{% for product in products %}` من بيانات متجرك |
| أقسام ثابتة | `{% for category in categories %}` ديناميكي |
| فيديو ثابت | `theme.settings.hero_video_url` قابل للتغيير |
| واتساب ثابت | `theme.settings.whatsapp_number` من الإعدادات |
| newsletter بدون ربط | `salla.newsletter.subscribe()` مربوط بـ SDK |
| إضافة للسلة وهمي | `salla.cart.addItem()` يضيف فعلياً |
| بدون twilight.json | ✅ كامل مع components و settings |
| بدون ترجمة | ✅ ar.json + en.json |
