(function () {
  var container = document.getElementById("webmentions");
  if (!container) return;

  var target = container.getAttribute("data-url");
  if (!target) return;

  // Query with and without trailing slash to catch both
  var bare = target.replace(/\/$/, "");
  var url =
    "https://webmention.io/api/mentions.jf2?per-page=100&sort-by=published&sort-dir=up" +
    "&target[]=" + encodeURIComponent(bare + "/") +
    "&target[]=" + encodeURIComponent(bare);

  fetch(url)
    .then(function (r) { return r.json(); })
    .then(function (data) {
      if (!data.children || data.children.length === 0) return;

      var likes = [], reposts = [], replies = [], mentions = [];
      data.children.forEach(function (m) {
        switch (m["wm-property"]) {
          case "like-of": likes.push(m); break;
          case "repost-of": reposts.push(m); break;
          case "in-reply-to": replies.push(m); break;
          case "mention-of": mentions.push(m); break;
        }
      });

      var html = "<h3>Responses</h3>";

      if (likes.length > 0) {
        html += "<p><i class='fa fa-heart'></i> " +
          likes.length + " like" + (likes.length !== 1 ? "s" : "") + " &mdash; ";
        likes.forEach(function (l, i) {
          if (i > 0) html += " ";
          var name = l.author ? esc(l.author.name) : "someone";
          var aUrl = l.author ? esc(l.author.url) : "#";
          var photo = l.author ? l.author.photo : null;
          if (photo) {
            html += "<a href='" + aUrl + "' title='" + name + "'>" +
              "<img src='" + esc(photo) + "' alt='" + name +
              "' width='24' height='24' style='border-radius:50%' loading='lazy' /></a>";
          } else {
            html += "<a href='" + aUrl + "'>" + name + "</a>";
          }
        });
        html += "</p>";
      }

      if (reposts.length > 0) {
        html += "<p><i class='fa fa-retweet'></i> " +
          reposts.length + " boost" + (reposts.length !== 1 ? "s" : "") + " &mdash; ";
        reposts.forEach(function (r, i) {
          if (i > 0) html += ", ";
          var name = r.author ? esc(r.author.name) : "someone";
          var aUrl = r.author ? esc(r.author.url) : "#";
          html += "<a href='" + aUrl + "'>" + name + "</a>";
        });
        html += "</p>";
      }

      if (replies.length > 0) {
        html += "<h4>" + replies.length + " repl" +
          (replies.length !== 1 ? "ies" : "y") + "</h4><ul>";
        replies.forEach(function (r) {
          var name = r.author ? esc(r.author.name) : "someone";
          var aUrl = r.author ? esc(r.author.url) : "#";
          html += "<li><strong><a href='" + aUrl + "'>" + name + "</a></strong>";
          if (r.content && r.content.text) {
            html += "<p>" + esc(r.content.text) + "</p>";
          }
          var date = r.published || r["wm-received"];
          if (date) {
            html += "<small>" + new Date(date).toLocaleDateString() + "</small>";
          }
          html += "</li>";
        });
        html += "</ul>";
      }

      if (mentions.length > 0) {
        html += "<h4>" + mentions.length + " mention" +
          (mentions.length !== 1 ? "s" : "") + "</h4><ul>";
        mentions.forEach(function (m) {
          var name = m.author ? esc(m.author.name) : esc(m.url);
          html += "<li><a href='" + esc(m.url) + "'>" + name + "</a>";
          if (m.content && m.content.text) {
            html += ": " + esc(m.content.text);
          }
          html += "</li>";
        });
        html += "</ul>";
      }

      container.innerHTML = html;
    })
    .catch(function (err) {
      console.warn("Webmentions fetch failed:", err);
    });

  function esc(str) {
    if (!str) return "";
    var div = document.createElement("div");
    div.appendChild(document.createTextNode(str));
    return div.innerHTML;
  }
})();
