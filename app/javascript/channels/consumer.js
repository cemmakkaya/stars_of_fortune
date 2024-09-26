import consumer from "./consumer"

consumer.subscriptions.create({ channel: "GameChannel", id: gameId }, {
    received(data) {
        if (data.action === 'start_game') {
            this.startGame(data.countdown);
        }
    },

    startGame(countdown) {
        // Hier Logik zum Starten des Spiels implementieren
        console.log(`Game starting in ${countdown} seconds`);
        // Aktualisieren Sie die Benutzeroberfläche, um den Countdown anzuzeigen
        // Starten Sie die Spiellogik
    }
});