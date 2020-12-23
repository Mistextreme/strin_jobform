$(function () {
    function display(bool) {
        if(bool) {
            $("#container").show();
        } else {
            $("#container").hide();
        }
    }

    function setData(item) {
        player = item.player
        $("#heading").text(item.label)
        $("#firstname").text('Firstname: ' + player.firstname)
        $("#lastname").text('Lastname: ' + player.lastname)
        $("#phone_number").text('Phone: ' + player.phone)
    }

    display(false)

    window.addEventListener("message", function(event) {
        item = event.data;
        if(item.type === "ui") {
            if(item.status == true) {
                display(true);
                setData(item);
                $
                form_job = item.job
            } else {
                display(false);
                form_job = item.job
            }
        }
    })

    document.onkeyup = function (data) {
        if (data.which == 27) {
            $.post("http://strin_jobform/exit_form", JSON.stringify({}));
            return
        }
    };

    $("#close").click(function() {
        $.post("http://strin_jobform/exit_form", JSON.stringify({}));
        return
    })

    $("#submit").click(function() {
        let text1 = $("#textarea_wayjoc").val()
        let text2 = $("#textarea_tuaby").val()
        if (text1.length >= 100 || text2.length >= 100) {
            $.post("http://strin_jobform/exit_form", JSON.stringify({
                error: "~r~Too long!"
            }));
            display(false)
            return;
        } else if (!text1 || !text2) {
            $.post("http://strin_jobform/exit_form", JSON.stringify({
                error: "~r~Some text area is empty!"
            }));
            display(false)
            return;
        } else if (text1.length < 20 || text2.length < 20) {
            $.post("http://strin_jobform/exit_form", JSON.stringify({
                error: "~r~Too short!"
            }));
            display(false)
            return;
        }
        $.post("http://strin_jobform/send_form", JSON.stringify({
            wayjoc: text1,
            tuaby: text2,
            job: item.job,
        }));
        return;
    })
})