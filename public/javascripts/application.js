
function keypress() {
  var prev = '';
  return function() {
    var ab = $(this).attr('id');
    if(prev != $(this).val()) {
      var input = $(this).val();
      var thing = $('.thing-wrapper#' + ab + ' .thing');
      format(thing, input);
    }
    prev = $(this).val();
  };
};

function format(container, text) {
  if(text.match(/^https?:/)) {
    container.html($('<a />').attr('href', text));
    container.embedly({
      key: 'd2b9b6464bf211e1ab1c4040d3dc5c07',
      method: 'after',
      maxWidth: 460,
      maxHeight: 200
    });
  } else {
    container.text(text);
    formatText(container);
  }
};

// based on http://la.ma.la/misc/js/takahashi_oop.html
function formatText(element) {
  var child = element.get(0);
  var parent = element.parent().get(0);
  with(child.style) {
    fontSize = "10px";
    display = "inline";
  }
  var parent_w = parent.offsetWidth;
  var parent_h = parent.offsetHeight;
  var child_w = child.offsetWidth;
  var new_fs = Math.ceil((parent_w/child_w) * 9);
  if(new_fs > 10000) { return }
  with(child.style) {
    fontSize = new_fs + "px";
  }
  var child_h = child.offsetHeight;
  if(child_h > parent_h) {
    var new_fs = Math.ceil((parent_h/child_h) * new_fs * 0.85);
    with(child.style) {
      fontSize = new_fs + "px";
    }
  }
};
