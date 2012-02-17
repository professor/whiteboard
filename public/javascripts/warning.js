var confirmation_needed = true;

window.onbeforeunload = confirmExit;

function confirmExit(){
  if(confirmation_needed){
	 return " ";
  }
}