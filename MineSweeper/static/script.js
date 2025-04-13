

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
        const child = cell.children[0];
        if (!child || child.tagName !== 'BUTTON') {
            return;
        }
        const isFlagged = data.cell.state === "Flagged";
        if (isFlagged) {
            child.innerHTML = '🚩';
        } else {
            child.innerHTML = '　';
        }
    });
    
    return false;
}

function handleReset() {
    fetch(`/reset`, {
        method: 'GET',
        headers: {
            'Content-Type': 'application/json'
        }
    })
    .then(response => response.json())
    .then(data => {
        const grid = document.getElementById('grid');
        grid.innerHTML = '';
        for (let row = 0; row < data.rows; row++) {
            const rowDiv = document.createElement('div');
            rowDiv.className = 'row';
            for (let col = 0; col < data.cols; col++) {
                const cell = document.createElement('div');
                cell.id = `cell-${row}-${col}`;
                cell.className = 'cell';
                cell.onclick = () => handleClick(row, col);
                cell.oncontextmenu = (event) => handleFlag(event, row, col);
                rowDiv.appendChild(cell);
            }
            grid.appendChild(rowDiv);
        }
    });
}