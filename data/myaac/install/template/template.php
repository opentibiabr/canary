<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN"
    "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml" dir="<?= $locale['direction']; ?>" lang="<?= $locale['lang']; ?>"
      xml:lang="<?= $locale['lang']; ?>">
<head>
    <meta http-equiv="Content-Type" content="text/html; charset=<?= $locale['encoding']; ?>"/>
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title><?= $locale['installation']; ?> - MyAAC</title>
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.1.3/dist/css/bootstrap.min.css" rel="stylesheet"
          integrity="sha384-1BmE4kWBq78iYhFldvKuhfTAU6auU8tT94WrHftjDbrCEXSU1oBoqyl2QvZ6jIW3" crossorigin="anonymous">
    <script type="text/javascript" src="<?= BASE_URL; ?>tools/js/jquery.min.js"></script>
    <link rel="stylesheet" type="text/css" href="<?= BASE_URL; ?>install/template/style.css"/>
</head>
<body class="text-center">
<main class="install">
    <div class="fs-1 fw-bold pb-3">MyAAC <?= $locale['installation']; ?></div>
    <div class="container_install row shadow">
        <div class="card col-8 py-3">
            <?php
            if (isset($locale['step_' . $step . '_title'])) {
                echo '<p class="fs-2 fw-bold">' . $locale['step_' . $step . '_title'] . '</p>';
            } else {
                echo '<p class="fs-2 fw-bold">' . $locale['step_' . $step] . '</p>';
            }
            echo $content;
            ?>
        </div>
        <div class="col-4 p-0">
            <div class="card-header bg-dark text-white fs-4 fw-bold mb-3"><?= $locale['steps']; ?></div>
            <ul class="ps-0">
                <?php
                $i = 0;
                foreach ($steps as $key => $value) {
                    echo '<li class="mx-3 my-2 py-1' . ($step == $value ? ' current' : '') . '">' . ++$i . '. ' . $locale['step_' . $value] . '</li>';
                }
                ?>
            </ul>
        </div>
        <div class="break"></div>
    </div>
    <div class="pt-3">
        <p style="text-align: center;"><?= base64_decode('UG93ZXJlZCBieSA8YSBocmVmPSJodHRwczovL2dpdGh1Yi5jb20vb3BlbnRpYmlhYnIvbXlhYWMiIHRhcmdldD0iX2JsYW5rIj5PcGVuVGliaWFCUjwvYT4gYW5kIENvbnRyaWJ1dG9ycy4=') ?></p>
    </div>
</main>
</body>
</html>
