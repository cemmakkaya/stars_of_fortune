document.addEventListener('DOMContentLoaded', () => {
    const gameBoard = document.getElementById('game-board');
    if (!gameBoard) return;
  
    const gameId = gameBoard.dataset.gameId;
    const gameStatus = document.getElementById('game-status');
    const countdown = document.getElementById('countdown');
    const timer = document.getElementById('timer');
    const cardSelection = document.getElementById('card-selection');
    const betInput = document.getElementById('bet-input');
    const gameResult = document.getElementById('game-result');
  
    let selectedCard = null;
  
    const channel = createChannel(gameId);
  
    channel.received(data => {
      switch(data.action) {
        case 'start_game':
          startGame(data.countdown);
          break;
        case 'game_result':
          showGameResult(data);
          break;
      }
    });
  
    function startGame(countdownTime) {
      gameStatus.textContent = 'in_progress';
      countdown.style.display = 'block';
      cardSelection.style.display = 'block';
      betInput.style.display = 'block';
  
      let timeLeft = countdownTime;
      timer.textContent = timeLeft;
  
      const countdownInterval = setInterval(() => {
        timeLeft--;
        timer.textContent = timeLeft;
  
        if (timeLeft <= 0) {
          clearInterval(countdownInterval);
          submitSelection();
        }
      }, 1000);
    }
  
    cardSelection.addEventListener('click', (event) => {
      if (event.target.classList.contains('card-button')) {
        selectedCard = event.target.dataset.card;
        document.querySelectorAll('.card-button').forEach(btn => btn.classList.remove('selected'));
        event.target.classList.add('selected');
      }
    });
  
    document.getElementById('place-bet').addEventListener('click', submitSelection);
  
    function submitSelection() {
      if (!selectedCard) return;
  
      const betAmount = document.getElementById('bet-amount').value;
      
      fetch(`/games/${gameId}`, {
        method: 'PATCH',
        headers: {
          'Content-Type': 'application/json',
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content
        },
        body: JSON.stringify({ selected_card: selectedCard, bet_amount: betAmount })
      });
  
      cardSelection.style.display = 'none';
      betInput.style.display = 'none';
    }
  
    function showGameResult(data) {
      gameStatus.textContent = 'completed';
      countdown.style.display = 'none';
      gameResult.style.display = 'block';
  
      document.getElementById('winning-card').textContent = data.winning_card;
  
      const winnersList = document.getElementById('winners-list');
      winnersList.innerHTML = '<h4>Winners:</h4>';
      data.winners.forEach(winner => {
        winnersList.innerHTML += `<p>${winner.username}: +${winner.winnings} C-Bucks</p>`;
      });
  
      const losersList = document.getElementById('losers-list');
      losersList.innerHTML = '<h4>Losers:</h4>';
      data.losers.forEach(loser => {
        losersList.innerHTML += `<p>${loser.username}: -${loser.losses} C-Bucks</p>`;
      });
    }
  
    function createChannel(gameId) {
        return App.cable.subscriptions.create({ channel: "GameChannel", id: gameId }, {
          received(data) {
            this.received(data);
          }
        });
    }
});