$(document).ready(function () {

    // get the race results and put them into a table
    $.getJSON("https://dt8ucxb8ol.execute-api.us-east-1.amazonaws.com/prod/getRaceResults", function (data) {

        raceResults = data;
        var date;
        var driver;
        var track;
        var position;

        $.each(data, function(index, raceResult) {
            date = raceResult.date;
            driver = raceResult.driver;
            track = raceResult.track;
            position = raceResult.position;

            $("#raceResults").append("<tr><td>" + date + "</td><td>" + driver + "</td><td>" + track + "</td><td>" + position + "</td></tr>");
        });
    });

    // create the race result
    $("button").click(function () {

        var date = $("#date").val();
        var driver = $("#driver").val();
        var track = $("#track").val();
        var position = $("#position").val();

        var body = {
            "date" : date,
            "driver" : driver,
            "track" : track,
            "position" : position
        };

        $.post("https://dt8ucxb8ol.execute-api.us-east-1.amazonaws.com/prod/createRaceResult", JSON.stringify(body), function(data) {
            alert("race result created successfully");
        }, "text");
    });
});