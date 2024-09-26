import consumer from "./channels/consumer"

document.addEventListener('turbo:load', () => {
    const gameContainer = document.getElementById('game-container');
    if (!gameContainer) return;

    const gameId = gameContainer.dataset.gameId;
    const statusElement = document.getElementById('status');
    const countdownElement = document.getElementById('countdown');
    const timerElement = document.getElementById('timer');
    const gameBoardElement = document.getElementById('game-board');
    const resultElement = document.getElementById('result');
    const winningCardElement = document.getElementById('winning-card');
    const winnersElement = document.getElementById('winners');
    const losersElement = document.getElementById('losers');

    const channel = consumer.subscriptions.create({ channel: "GameChannel", id: gameId }, {
        received(data) {
            if (data.action === 'start_game') {
                this.startGame(data.countdown);
            } else if (data.action === 'game_result') {
                this.showResult(data);
            }
        },

        startGame(countdown) {
            statusElement.textContent = 'in_progress';
            countdownElement.style.display = 'block';
            gameBoardElement.style.display = 'block';

            let timeLeft = countdown;
            const countdownTimer = setInterval(() => {
                timerElement.textContent = timeLeft;
                timeLeft -= 1;
                if (timeLeft < 0) {
                    clearInterval(countdownTimer);
                    countdownElement.style.display = 'none';
                }
            }, 1000);
        },

        showResult(data) {
            gameBoardElement.style.display = 'none';
            resultElement.style.display = 'block';
            statusElement.textContent = 'completed';
            winningCardElement.textContent = data.winning_card;

            winnersElement.innerHTML = '<h3>Winners:</h3>' + data.winners.map(w =>
                `<p>${w.username} won ${w.winnings} C-Bucks</p>`
            ).join('');

            losersElement.innerHTML = '<h3>Losers:</h3>' + data.losers.map(l =>
                `<p>${l.username} lost ${l.losses} C-Bucks</p>`
            ).join('');
        }
    });

    // Event listeners for game interactions
    const cards = document.querySelectorAll('.card');
    const placeBetButton = document.getElementById('place-bet');
    const betAmountInput = document.getElementById('bet-amount');

    let selectedCard = null;

    cards.forEach(card => {
        card.addEventListener('click', () => {
            cards.forEach(c => c.classList.remove('selected'));
            card.classList.add('selected');
            selectedCard = card.dataset.card;
        });
    });

    placeBetButton.addEventListener('click', () => {
        if (!selectedCard || !betAmountInput.value) {
            alert('Please select a card and enter a bet amount');
            return;
        }

        fetch(`/games/${gameId}`, {
            method: 'PATCH',
            headers: {
                'Content-Type': 'application/json',
                'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
            },
            body: JSON.stringify({
                selected_card: selectedCard,
                bet_amount: betAmountInput.value
            })
        }).then(response => {
            if (!response.ok) {
                throw new Error('Network response was not ok');
            }
            gameBoardElement.style.display = 'none';
        }).catch(error => {
            console.error('Error:', error);
            alert('There was a problem submitting your bet. Please try again.');
        });
    });
});