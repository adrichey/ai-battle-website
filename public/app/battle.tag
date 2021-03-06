<battle>
  <style>

    .battle-board {
      overflow: hidden;
      position: relative;
    }

    .battle-field,
    .battle-row {
      display: flex;
    }

    .battle-field > .roster-blue {
      order: 1;
      width: 140px;
    }
    .battle-field > .battle-board {
      order: 2;
    }
    .battle-field > .roster-red {
      order: 3;
      width: 140px;
    }

    .battle-field > .roster-blue .player-alive {
      background-color: #151f7d;
    }

    .battle-field > .roster-red .player-alive {
      background-color: #6a1f28;
    }

    .player-dead {
      opacity: 0.6;
    }

    .roster h3 {
      margin: 0;
      padding: 0.3em;
    }

    .roster a {
      text-decoration: none;
      font-weight: bold;
      color: #fff;
    }

    .roster a:hover,
    .roster a:focus,
    .roster a:active {
      color: #fff;
      text-decoration: underline;
    }

    ul,
    li {
      list-style: none;
      margin: 0;
      padding: 0.2em;
    }

    .battle-tile {
      width: 64px;
      height: 64px;
      background: url(../img/grass_square.gif);
      border: 1px dotted #10380d80;
      position: relative;
      text-align: center;
    }

    .battle-tile .small-tile {
      margin: 16px;
    }

    .battle-tile.scenery {
      z-index: 1;
    }

    .battle-tile.scenery img {
      max-height: 100%;
    }

    .battle-controls {
      text-align: center;
    }

    .battle-turn {
      display: flex;
      padding: 0.4em 0;
    }

    .fainted {
      animation: deathflash 2s linear infinite alternate;
    }

    .team-blue {
      background: #00a;
    }

    .team-red {
      background: #a00;
    }

    .diamond-count {
      padding: 0 1.4em;
    }

    .diamond-total {
      font-weight: bold;
    }

    .indicator {
      position: absolute;
      right: 4px;
      top: 38px;
      color: #fff;
      font-size: 8px;
      font-family: "Press Start 2P";
      padding: 0 2px 0 3px;
      border: solid 1px #fff;
      opacity: 0.8;
    }

    @keyframes deathflash {
      from {
        filter: invert(0%);
        -webkit-filter: invert(0%);
      }
      to {
        filter: invert(90%);
        -webkit-filter: invert(90%);
      }
    }

    .end-message {
      width: 100%;
      background-color: rgba(44, 44, 44, 0.8);
      position: absolute;
      top: 50%;
      z-index: 4;
      font-size: 2em;
      text-align: center;
      font-family: "Press Start 2P";
      padding: 0.5em;
      transform: translateY(-50%);
    }

    .battle-turn .turn:first-child {
      text-align: right;
    }

    .turn {
      font-size: 16px;
      font-family: "Press Start 2P";
      flex: 1;
      padding: 0 1em;
      text-align: left;
    }

    .slider {
      width: 400px;
    }

    .messages {
      top: 2vw;
      width: 100%;
      font-size: 16px;
      color: white;
      text-align: center;
      font-family: "Press Start 2P";
      padding: 0.3em 0;
    }

    .tile-name {
      position: absolute;
      color: #ffffffd0;
      font-size: 8px;
      font-family: "Press Start 2P";
      padding: 0 3px;
      border: solid 1px #ffffff80;
      width: 62px;
      z-index: 2;
      overflow: hidden;
      text-overflow: ellipsis;
    }

  </style>
  <h2>{ title }</h2>
  <div class="battle-field" if={ game }>
    <div class={ 'roster-blue': i === 0, 'roster-red': i === 1, roster: true } each={ team, i in game.teams }>
      <h3>{ i === 0 ? 'Blue' : 'Red' } Team</h3>
      <span class="diamond-count diamond-total">💎 { game.totalTeamDiamonds[i] }</span>
      <ul>
        <li each={ player in team } class={ (player.health <= 0 ? 'player-dead' : 'player-alive') + ' ' + user.getCurrentUserClass(player.name) }>
          { player.health <= 0 ? '💀 ' : '' }<a href="https://github.com/{ player.name }">{ player.name }</a>
          <br><span class="diamond-count">💎 { player.diamondsEarned }</span>
        </li>
      </ul>
    </div>
    <div class="battle-board">
      <div class="messages">{ game.killMessage || game.attackMessage || '&nbsp;' }</div>
      <div class="end-message" if={ game.ended }>
        { game.winningTeam === 0 ? 'Blue' : 'Red' } Team Wins!
      </div>
      <div class="battle-row" each={ row, y in game.board.tiles } no-reorder>
        <div class="battle-tile { tile.type === 'Impassable' ? 'scenery' : '' }" each={ tile, x in row } no-reorder>
          <img src="img/tree.png" if={ tile.subType === 'Tree' }>
          <virtual if={ tile.subType === 'DiamondMine' }>
            <img class="small-tile" src="img/diamond_mine.png" if={ !tile.owner }>
            <virtual if={ tile.owner && tile.owner.team === 0 }>
              <img class="small-tile" src="img/diamond_mine_blue.gif" title={ 'Owned by ' + tile.owner.name }>
              <span class="indicator team-blue" title={ 'Owned by ' + tile.owner.name }>{ tile.owner.name.substring(0, 2) }<span>
            </virtual>
            <virtual if={ tile.owner && tile.owner.team === 1 }>
              <img class="small-tile" src="img/diamond_mine_red.gif" title={ 'Owned by ' + tile.owner.name }>
              <span class="indicator team-red" title={ 'Owned by ' + tile.owner.name }>{ tile.owner.name.substring(0, 2) }<span>
            </virtual>
          </virtual>
          <img class="small-tile" src="img/healing_well.gif" if={ tile.subType === 'HealthWell' }>
          <div if={ tile.type === 'Hero' || tile.subType === 'BlueFainted' || tile.subType === 'RedFainted' } class="tile-name { user.getCurrentUserClass(game.heroes[tile.id].name) }" style="background: linear-gradient(to right, hsl({ tile.health * 1.2 }, 40%, 30%) 0%, hsl({ tile.health * 1.2 }, 80%, 30%) { tile.health }%, #ffffff40 0%);" title={ game.heroes[tile.id].name }>{ game.heroes[tile.id].name }</div>
          <img class="small-tile" src="img/blue_knight.gif" if={ tile.subType === 'BlackKnight' }>
          <img class="small-tile" src="img/red_knight.gif" if={ tile.subType === 'Adventurer' }>
          <img class="small-tile fainted" src="img/blue_knight_fainted.gif" if={ tile.subType === 'BlueFainted' }>
          <img class="small-tile fainted" src="img/red_knight_fainted.gif" if={ tile.subType === 'RedFainted' }>
        </div>
      </div>
    </div>
  </div>
  <div class="battle-controls" if={ game }>
    <div class="battle-turn">
      <span class="turn">Turn: { game.turn }</span>
      <input type="range" class="slider" min="0" value="0" ref="slider" max={ game.maxTurn } oninput={ jumpToTurnFromInput }>
      <span class="turn">{ game.maxTurn }</span>
    </div>
    <div>
      <button class="stop-game" onclick={ stopGame }>⏹ Stop</button>
      <button class="play-pause-game" onclick={ toggleAutoPlay }>
        <virtual if={ ticker }>⏸ Pause</virtual>
        <virtual if={ !ticker }>⏵ Play</virtual>
      </button>
    </div>
  </div>
  <script>
    let tag = this;
    let gameSpeed = 400;
    let sliderBufferDelay = 10;

    route('/game/*', function (id) {
      fetchGame(id);
    });

    function fetchGame (id) {
      $.getJSON(`api/game/${id}`, loadGame);
    }

    function loadGame (data) {
      tag.gameId = data.id;
      tag.title = `Battle #${data.id}`;
      tag.battle = data;

      tag.boardHeight = tag.battle.initial_map.length;
      tag.boardWidth = tag.battle.initial_map[0].length;
      tag.initialMap = tag.battle.initial_map;
      tag.events = tag.battle.events;
      tag.maxTurn = tag.battle.events.length;
      tag.isLatest = tag.latest;
      tag.game = createGame(tag.initialMap);

      if (tag.refs.slider) {
        tag.refs.slider.value = 0;
      }

      tag.update();
    }

    tag.on('before-mount', function (e) {
      if (location.hash.indexOf('game') > -1) {
        route.exec();
      } else {
        $.getJSON('api/game', loadGame);
      }
    });

    /**
     * Creates a new game using the initial map.
     * @param  {Object} map
     *     Initial map state
     * @return {Game}
     *     New game object
     */
    function createGame (map) {
      let boardSize = map.length;
      let engine = new GameEngine();
      let GameClass = engine.getGame();
      let game = new GameClass(boardSize);
      let events = tag.events;

      game.maxTurn = events.length;

      $.each(map, function (y, row) {
        $.each(row, function (x, tile) {
          setupGameTile(game, tile);
        });
      });

      // Because we aren't adding heroes in the correct order, we need to sort them by ID to ensure
      // nobody goes out of turn.
      game.heroes.sort(function (a, b) {
          return a.id - b.id;
      });

      return game;
    }

    function setupGameTile (game, tile) {
      let tileAdder = game[`add${tile.type}`];

      if ($.isFunction(tileAdder)) {
        tileAdder.call(
          game,
          tile.distanceFromTop,
          tile.distanceFromLeft,
          tile.name,
          tile.team,
          tile.id
        );
      } else if (tile.type !== 'Unoccupied') {
        throw new Error(`No method found to add tile type of "${tile.type}"`);
      }
    }

    stopGame () {
      tag.stopAutoPlay();
      tag.jumpToTurn(0);
    }

    jumpToTurnFromInput (input) {
      input.preventUpdate = true;
      tag.jumpToTurn(parseInt(input.target.value, 10));
    }

    /**
     * Updates the tag so any user-specific UI elements can be displayed.
     */
    user.on('login', function () {
      tag.update();
    });

    /**
     * @public
     *
     * Jumps to a specific turn in the game by creating a new game and playing
     * all of the turns needed to reach the given turn.
     *
     * @param  {Number} turn
     *     The turn to jump to
     * @return {Game}
     *     The game class
     */
    jumpToTurn (turn) {
      let initialMap = tag.initialMap;
      let events = tag.events;
      let game = createGame(initialMap);

      tag.game = game;

      while (turn > 0) {
        tag.nextTurn(true);
        turn--;
      }

      tag.update();
    }

    toggleAutoPlay () {
      if (!tag.ticker) {
        tag.ticker = setInterval(tag.nextTurn, gameSpeed);
      } else {
        tag.stopAutoPlay();
      }
    }

    stopAutoPlay () {
      if (tag.ticker) {
        clearInterval(tag.ticker);
        tag.ticker = null;
      }
    }

    /**
     * Go the next turn of the game, if possible.
     *
     * @param {Boolean} skipUpdate
     *     Prevents the tag from being updated when true.
     */
    tag.nextTurn = function nextTurn (skipUpdate) {
      let game = tag.game;
      let events = tag.events;
      let turn = game.turn;
      let heroAction;

      if (events[turn] !== undefined) {
        heroAction = events[turn].action;
        game.handleHeroTurn(heroAction);

        if (skipUpdate !== true) {
          tag.refs.slider.value = turn;
          tag.update();
        }
      }
    };

  </script>
</battle>