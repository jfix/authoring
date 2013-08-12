//  Scriptlets code written by Jeremy Edmiston
//  The functions have been adapted from various sources
//  and re-written to provide maximum flexibility
//  and compatability with various browsers.

//Global Declarations
var ie = (document.all) ? true: false;

function toggleClass(objClass) {
    //  This function will toggle obj visibility of an Element
    //  based on Element's Class
    //  Works with IE and Mozilla based browsers
    
    if (getElementByClass(objClass).style.display == "none") {
        showClass(objClass)
    } else {
        hideClass(objClass)
    }
}

function hideClass(objClass) {
    //  This function will hide Elements by object Class
    //  Works with IE and Mozilla based browsers
    
    var elements = (ie) ? document.all: document.getElementsByTagName('*');
    for (i = 0; i < elements.length; i++) {
        if (elements[i].className == objClass) {
            elements[i].style.display = "none";            
            elements[i].style.visibility = "hidden";
        }
    }
}

function showClass(objClass) {
    //  This function will show Elements by object Class
    //  Works with IE and Mozilla based browsers
    var elements = (ie) ? document.all: document.getElementsByTagName('*');
    for (i = 0; i < elements.length; i++) {
        if (elements[i].className == objClass) {
            elements[i].style.display = "inline";
            elements[i].style.visibility = "visible";
        }
    }
}

function toggleID(objID) {
    //  This function will toggle obj visibility of an Element
    //  based on Element's ID
    //  Works with IE and Mozilla based browsers
    var element = (ie) ? document.all(objID): document.getElementById(objID);
    if (element.style.display == "none") {
        showID(objID)
    } else {
        hideID(objID)
    }
}

function hideID(objID) {
    //  This function will hide Elements by object ID
    //  Works with IE and Mozilla based browsers
    var element = (ie) ? document.all(objID): document.getElementById(objID);
    element.style.display = "none"
}

function showID(objID) {
    //  This function will show Elements by object ID
    //  Works with IE and Mozilla based browsers
    var element = (ie) ? document.all(objID): document.getElementById(objID);
    element.style.display = "block"
}

function getElementByClass(objClass) {
    //  This function is similar to 'getElementByID' since there
    //  is no inherent function to get an element by it's class
    //  Works with IE and Mozilla based browsers
    var elements = (ie) ? document.all: document.getElementsByTagName('*');
    for (i = 0; i < elements.length; i++) {
        //alert(elements[i].className)
        //alert(objClass)
        if (elements[i].className == objClass) {
            return elements[i]
        }
    }
}

function toggle(className) {
    if (className == 'contentModelAE') {
        if (document.forms[ 'form1'].elements[0].checked == false) {
            hideClass('contentModelAE');
            document.forms[ 'form1'].elements[2].checked = false;
        } else {
            showClass('contentModelAE');
            if (document.forms[ 'form1'].elements[1].checked == false) {
                document.forms[ 'form1'].elements[2].checked = false;
            } else {
                document.forms[ 'form1'].elements[2].checked = true;
            }
        }
    } else if (className == 'upcast') {
        if (document.forms[ 'form1'].elements[1].checked == false) {
            hideClass('upcast');
            document.forms[ 'form1'].elements[2].checked = false;
        } else {
            showClass('upcast');
            if (document.forms[ 'form1'].elements[0].checked == false) {
                document.forms[ 'form1'].elements[2].checked = false;
            } else {
                document.forms[ 'form1'].elements[2].checked = true;
            }
        }
    } else if (className == 'all') {
        if (document.forms[ 'form1'].elements[2].checked == false) {
            hideClass('upcast');
            hideClass('contentModelAE');
            document.forms[ 'form1'].elements[0].checked = false;
            document.forms[ 'form1'].elements[1].checked = false;
        } else {
            showClass('upcast');
            showClass('contentModelAE');
            document.forms[ 'form1'].elements[0].checked = true;
            document.forms[ 'form1'].elements[1].checked = true;
        }
    }
}

