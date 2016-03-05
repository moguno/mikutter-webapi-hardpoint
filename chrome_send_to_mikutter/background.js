chrome.browserAction.onClicked.addListener(
  function(tab){
    var xhr = new XMLHttpRequest();
    xhr.open("GET", "http://127.0.0.1:39080/test?title=" + encodeURI(tab.title) + "&url=" + encodeURI(tab.url), true);
    xhr.send(null);
  }
);
