/**
 * Created by Ievgen on 25.07.2017.
 */
onload = function (){
for (var lnk = document.links, j = 0; j < lnk.length; j++)
    if (lnk [j].href == document.URL) lnk [j].style.color = 'white';
}

function add_user_page() {
    parent.location='create_user'
}

function get_users_data() {
    var xhr = new XMLHttpRequest();
    var name = document.getElementById("name").value;
    var qty = document.getElementById("qty").value;
    var params = 'name=' + name + '&qty=' + qty;
    xhr.open("GET", 'get_users/?' + params, true);
    xhr.onreadystatechange = function () {
        if(xhr.readyState === XMLHttpRequest.DONE && xhr.status === 200) {
            console.log(xhr.responseText);
        };
    };
    xhr.send();


}