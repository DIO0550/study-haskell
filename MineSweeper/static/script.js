

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

function handleFlag(event, row, col) {
    event.preventDefault()

    fetch(`/flag`, {
        method: 'POST',
        headers: {
            'Content-Type': 'application/json'
        },
        body: JSON.stringify({cellRow: row, cellCol: col})
    })
    .then(response => response.json())
    .then(data => {
        const cell = document.getElementById(`cell-${row}-${col}`);
        const isFlagged = data.cell.state === "Flagged";
        if (isFlagged) {
            cell.innerHTML = '🚩';
        } else {
            cell.innerHTML = '　';
        }
    });
    
    return false;
}