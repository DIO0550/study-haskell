function handleClick(row, col) {
    fetch(`/click/${row}/${col}`, {method: 'POST'})
        .then(response => {
            if (response.ok) {
            }
        });
    return false;
}