(function() {
  var print = {
    date: function(date) {
      if (!date) {
        return '';
      } else {
        return '<span class="date">' + date + '</span>';
      }
    },
    tags: function(tags) {
      if (!tags) {
        return '';
      } else {
        return tags.split(" ").map(function(tag) {
          var trans = { translated: "번역", movie: "동영상" };
          return '<a href="#' + tag + '" class="tag tag-' + tag + '">' + (trans[tag] || tag) + '</a>';
        }).join(" ");
      }
    },
    author: function(author) {
      if (!author) {
        return '';
      } else {
        return '<span class="author">by ' + author + '</span>';
      }
    }
  };

  var renderData = function(links) {
    for (var i = 0, l = links.length; i < l; i ++) {
      var link = links[i];
      var li = link.parentElement;
      li.innerHTML = [
        print.date(link.dataset.date),
        print.tags(link.dataset.tags),
        li.innerHTML,
        print.author(link.dataset.author)
      ].join(" ");
    }
  };

  var articles = document.getElementsByClassName("article");
  renderData(articles);

  var tagFilter = function(tagName) {
    var tagLinks = document.getElementById("tags").children;
    var tags = [];
    for (var i = 0, l = tagLinks.length; i < l; i ++) {
      var tagLink = tagLinks[i];
      tags.push(tagLink.dataset.name);
    }
    tagName = tagName.slice(1);
    if (tags.indexOf(tagName) > -1) {
      console.log("eisxt");
      for (var i = 0, l = tagLinks.length; i < l; i ++) {
        var tagLink = tagLinks[i];
        if (tagName == tagLink.dataset.name) {
          tagLink.className = "tag tag-" + tagLink.dataset.name;
        } else {
          tagLink.className = "tag tag-disable";
        }
      }
      for (var i = 0, l = articles.length; i < l; i ++) {
        var article = articles[i];
        var li = article.parentElement;
        var articleTags = article.dataset.tags;
        li.hidden = !(articleTags && articleTags.split(" ").indexOf(tagName) > -1);
      }
    } else {
      console.log("no");
      for (var i = 0, l = tagLinks.length; i < l; i ++) {
        var tagLink = tagLinks[i];
        tagLink.className = "tag tag-" + tagLink.dataset.name;
      }
      for (var i = 0, l = articles.length; i < l; i ++) {
        var article = articles[i];
        var li = article.parentElement;
        li.hidden = false;
      }
    }
  };

  if ("onhashchange" in window) { // event supported?
    window.onhashchange = function () {
      tagFilter(window.location.hash);
    }
  } else { // event not supported:
    var storedHash = window.location.hash;
    window.setInterval(function () {
      if (window.location.hash != storedHash) {
        storedHash = window.location.hash;
        tagFilter(storedHash);
      }
    }, 100);
  }
  tagFilter(window.location.hash);
})();
