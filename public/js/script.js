var place = 0;
$('#next').click(function(ev) {
    $('audio')[0].src = $('a').get(place + 1).text;
    place = place + 1;
    $('audio')[0].play();
});

$('#search_it').click(function(ev) {
    var content = $('#search_box').val();
    $.post(
        '/search',
        {q:content},
        function(data) {
            console.log(data);
            $('.results')[0].innerHTML = data;
        })
})


//$('#audio').ended(function(ev) {
    //$('audio')[0].src = $('a').get(place + 1).text;
    //place = place + 1;
    //$('audio')[0].play();
//})
