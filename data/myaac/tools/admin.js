$(document).ready(function () {
  $('#update').qtip({
    content: {
      url: '/admin/tools/version.php',
    },
    show: {
      when: 'click',
      solo: true, // Only show one tooltip at a time
    },
    hide: 'unfocus',
    style: {
      tip: true, // Create speech bubble tip at the set tooltip corner above
      textAlign: 'center',
      name: 'light',
    },
    position: {
      corner: {
        tooltip: 'topRight',
      },
    },
  });
  $('#status-more').qtip({
    content: {
      url: '/admin/tools/status.php',
    },
    show: {
      when: 'click',
      solo: true, // Only show one tooltip at a time
    },
    hide: 'unfocus',
    style: {
      tip: true, // Create speech bubble tip at the set tooltip corner above
      textAlign: 'left',
      name: 'light',
    },
    position: {
      corner: {
        tooltip: 'top',
      },
    },
  });
});
