<recent-battles>
  <style>

    ul,
    ul > li {
      margin: 0;
      padding: 0;
    }

    ul > li {
      display: inline-block;
      padding: 0.1em 0.4em;
    }

    h3 {
      margin-bottom: 0.5em;
    }

    section {
      padding: 0.5em;
    }

    .battles {
      display: flex;
      flex-wrap: wrap;
    }

    .battle {
      width: 30%;
      background-color: #243341;
      margin-bottom: 1em;
      padding: 0.5em;
      margin: 0.5em;
    }

  </style>
  <h2>Today's Battles</h2>
  <section class="battles">
    <div class="battle" each={ battle in battles }>
      <h3><a href="#game/{ battle.id }">Battle #{ battle.id }</a></h3>
      <ul>
        <li each={ player in battle.players } class={ user.getCurrentUserClass(player) }>{ player }</li>
      </ul>
    </div>
  </section>

  <script>
    let tag = this;

    /**
     * Updates the tag so any user-specific UI elements can be displayed.
     */
    user.on('login', function () {
      tag.update();
    });

    tag.on('before-mount', function (e) {
      $.getJSON('/api/games/latest', function (data) {
        tag.battles = data;

        tag.battles.forEach(battle => {
          battle.players.sort();
        });

        tag.update();
      });
    });
  </script>
</recent-battles>