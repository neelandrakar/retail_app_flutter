export function removeTime(date) {
    var newDate =  new Date(date);  
    return new Date(
        newDate.getFullYear(),
        newDate.getMonth(),
        newDate.getDate()
    );
}
