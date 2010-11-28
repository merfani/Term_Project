function submitCall(){
       
       var val =  document.myform["start_index"];
	 document.myform.submit();
    }
     function submitform(newStart){
        document.myform["start_index"].value = newStart;
        document.myform.submit();
    }

    function submitorder(order){
      
        var currOrder = document.myform["order_field"].value;
        
        if(currOrder == order){
            var currDir = document.myform["order_direction"].value;
	    	if(currDir == "asc"){
			document.myform["order_direction"].value = "desc";
		}else{
			document.myform["order_direction"].value = "asc";
		}
        }else{
            document.myform["order_field"].value = order;
            document.myform["order_direction"].value = "asc";
        }
       
	document.myform.submit();  
  } 

// Popup window code
function newPopup(url) {
	popupWindow = window.open(
	url,'popUpWindow','height=800,width=600,left=10,top=10,resizable=yes,scrollbars=yes,toolbar=no,menubar=no,location=no,directories=no,status=yes');
}


