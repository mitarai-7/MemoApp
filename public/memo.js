function check_Content() {
    let title = document.querySelector('#memo_title').value;
    let text = document.querySelector('#memo_text').value;
    if (title.length === 0 || text.length === 0) {
        alert("未入力の項目があります");
        return false;
    }
    return true;
}

function addButton_Click() {
    if (check_Content()) {
        document.new_memo.submit();
    }
}

function deleteButton_Click(id) {
    var xhr = new XMLHttpRequest();
    xhr.open("DELETE", ('../memo/' + id), false);
    xhr.onreadystatechange = function () {
        if(this.readyState === XMLHttpRequest.DONE && this.status === 200) {
            document.location.href = '../list';
        }
    }
    xhr.send();
}

function Button_Click(id) {
    if (check_Content()) {
        var xhr = new XMLHttpRequest();
        xhr.open('PATCH', ('../edit/' + id), false);
        xhr.setRequestHeader('Content-type','application/x-www-form-urlencoded');
        xhr.onreadystatechange = function () {
            if(this.readyState === XMLHttpRequest.DONE && this.status === 200) {
                document.location.href = '../list';
            }
        }
        let title = document.querySelector('#memo_title').value;
        let text = document.querySelector('#memo_text').value;
        let param = 'id=' + id + '&title=' + title + '&text=' + text;
        xhr.send(param);
    }
}
