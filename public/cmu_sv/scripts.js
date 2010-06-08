//clear search
function clear_search(s) {
  if (s.defaultValue==s.value || s.value=='SEARCH') s.value = ""
}


function randomHeaderImage(images)
{
  var randPhoto=Math.floor(Math.random()*images.length); 
  document.writeln('<img alt="" border="0" id="pageHeaderPhoto" src="'+images[randPhoto]+'" width="748"/>');
}
