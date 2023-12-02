document.addEventListener('DOMContentLoaded', function() {
    let alertElement = document.querySelector('.alert');
    let closeButton = document.querySelector('.btn-close');


    if (localStorage.getItem('closedAlert')) {
        alertElement.style.display = 'none';
    }

    // Обробник події для кнопки закриття вікна
    closeButton.addEventListener('click', function() {
        localStorage.setItem('closedAlert', 'true');
    });
});