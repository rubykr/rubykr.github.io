(function() {
  var printDate = function(date) {
    if (!date) {
      return '';
    } else {
      return '<span class="date">' + date + '</span>';
    }
  };

  var printTags = function(tags) {
    if (!tags) {
      return '';
    } else {
      return tags.split(" ").map(function(tag) {
        var trans = { translated: "번역", movie: "동영상" };
        return '<span class="tag">' + (trans[tag] || tag) + '</span>';
      }).join(" ");
    }
  };

  var printAuthor = function(author) {
    if (!author) {
      return '';
    } else {
      return '<span class="author">by ' + author + '</span>';
    }
  };

  var renderData = function(links) {
    for (var i = 0, l = links.length; i < l; i ++) {
      var link = links[i];
      var li = link.parentElement;
      li.innerHTML = [
        printDate(link.dataset.date),
        printTags(link.dataset.tags),
        li.innerHTML,
        printAuthor(link.dataset.author)
      ].join(" ");
    }
  };
  var articles = document.getElementsByClassName("article");
  renderData(articles);
})();
