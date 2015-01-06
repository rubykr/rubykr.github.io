(function () {
  'use strict';
  var print, renderData, articles, tagFilter, storedHash;
  print = {
    date: function (date) {
      if (!date) {
        return '';
      }
      return '<span class="date">' + date + '</span>';
    },
    tags: function (tags) {
      if (!tags) {
        return '';
      }
      return tags.split(" ").map(function (tag) {
        var trans = { translated: "번역", movie: "동영상" };
        return '<a href="#' + tag + '" class="tag tag-' + tag + '">' + (trans[tag] || tag) + '</a>';
      }).join(" ");
    },
    author: function (author) {
      if (!author) {
        return '';
      }
      return '<span class="author">by ' + author + '</span>';
    }
  };
  renderData = function (links) {
    var i, l, link, li;
    for (i = 0, l = links.length; i < l; i += 1) {
      link = links[i];
      li = link.parentElement;
      li.innerHTML = [
        print.date(link.dataset.date),
        print.tags(link.dataset.tags),
        li.innerHTML,
        print.author(link.dataset.author)
      ].join(" ");
    }
  };
  articles = document.getElementsByClassName("article");
  tagFilter = function (tagName) {
    var tagLinks, tags, i, l, tagLink, article, li, articleTags;
    tagLinks = document.getElementById("tags").children;
    tags = [];
    for (i = 0, l = tagLinks.length; i < l; i += 1) {
      tagLink = tagLinks[i];
      tags.push(tagLink.dataset.name);
    }
    tagName = tagName.slice(1);
    if (tags.indexOf(tagName) > -1) {
      for (i = 0, l = tagLinks.length; i < l; i += 1) {
        tagLink = tagLinks[i];
        if (tagName === tagLink.dataset.name) {
          tagLink.className = "tag tag-" + tagLink.dataset.name;
        } else {
          tagLink.className = "tag tag-disable";
        }
      }
      for (i = 0, l = articles.length; i < l; i += 1) {
        article = articles[i];
        li = article.parentElement;
        articleTags = article.dataset.tags;
        li.hidden = !(articleTags && articleTags.split(" ").indexOf(tagName) > -1);
      }
    } else {
      for (i = 0, l = tagLinks.length; i < l; i += 1) {
        tagLink = tagLinks[i];
        tagLink.className = "tag tag-" + tagLink.dataset.name;
      }
      for (i = 0, l = articles.length; i < l; i += 1) {
        article = articles[i];
        li = article.parentElement;
        li.hidden = false;
      }
    }
  };

  if (window.hasOwnProperty("onhashchange")) { // event supported?
    window.onhashchange = function () {
      tagFilter(window.location.hash);
    };
  } else { // event not supported:
    storedHash = window.location.hash;
    window.setInterval(function () {
      if (window.location.hash !== storedHash) {
        storedHash = window.location.hash;
        tagFilter(storedHash);
      }
    }, 100);
  }
  renderData(articles);
  tagFilter(window.location.hash);
})();
