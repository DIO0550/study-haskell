

function handleClick(row, col) {
    fetch(`/click/${row}/${col}`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        }
    })
    .then(response => response.json())
    .then(data => {
        const cell = document.getElementById(`cell-${row}-${col}`);
        if (data.hasMine) {
            cell.innerHTML = '💣';
        } else {
            cell.innerHTML = data.neighborMines || '　';
        }
    });

    return false;
}

function handleFlag(row, col) {
    fetch(`/flag/${row}/${col}`, {
        method: 'POST'
    })
    .then(response => response.json())
    .then(data => {
        const cell = document.getElementById(`cell-${row}-${col}`);
        if (data.isFlagged) {
            cell.innerHTML = '🚩';
        } else {
            cell.innerHTML = '　';
        }
    });
    
    return false;
}