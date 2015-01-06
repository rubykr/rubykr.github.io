(function() {
  var printDate = function(date) {
    return '<span class="date">' + date + '</span>';
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

  var articles = document.getElementsByClassName("article");
  for (var i = 0, l = articles.length; i < l; i ++) {
    var article = articles[i];
    var li = article.parentElement;
    li.innerHTML = [
      printDate(article.dataset.date),
      printTags(article.dataset.tags),
      li.innerHTML,
      printAuthor(article.dataset.author)
    ].join(" ");
  }

  var docs = document.getElementsByClassName("doc");
  for (var i = 0, l = docs.length; i < l; i ++) {
    var doc = docs[i];
    var li = doc.parentElement;
    li.innerHTML = [
      printTags(doc.dataset.tags),
      li.innerHTML,
      printAuthor(doc.dataset.author)
    ].join(" ");
  }

  var books = document.getElementsByClassName("book");
  for (var i = 0, l = books.length; i < l; i ++) {
    var book = books[i];
    var li = book.parentElement;
    li.innerHTML = [
      printDate(book.dataset.date),
      printTags(book.dataset.tags),
      li.innerHTML
    ].join(" ");
  }


})();
