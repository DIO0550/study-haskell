

function handleClick(row, col) {
    fetch(`/click`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({cellRow: row, cellCol: col})
    })
    .then(response =>  response.json())
    .then(data => {
        const cell = document.getElementById(`cell-${row}-${col}`);
        const hasMine = data.cell.hasMine
        if (hasMine) {
            cell.innerHTML = '💣';
        } else {
            cell.innerHTML = data.cell.neighborMines || '　';
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