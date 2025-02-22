CREATE TABLE IF NOT EXISTS Club (
    id SERIAL PRIMARY KEY,
    name TEXT,
    stadium_name TEXT,
    stadium_seats INTEGER,
    national_team BOOLEAN
);

CREATE TABLE IF NOT EXISTS Player (
    id SERIAL PRIMARY KEY,
    name TEXT,
    country TEXT,
    birth DATE,
    position TEXT,
    foot TEXT,
    height INTEGER,
    highest_market_value DECIMAL
);

CREATE TABLE IF NOT EXISTS PlayerTakesRedCard (
    player_id INTEGER,
    match_id INTEGER,
    date DATE,
    PRIMARY KEY (player_id, match_id)
);

CREATE TABLE IF NOT EXISTS Match (
    id SERIAL PRIMARY KEY,
    home_club_id INTEGER,
    away_club_id INTEGER,
    date DATE,
    international_match BOOLEAN,
    home_score INTEGER,
    away_score INTEGER
);

CREATE TABLE IF NOT EXISTS PlayerScores (
    player_id INTEGER,
    match_id INTEGER,
    minute INTEGER,
    penalty BOOLEAN,
    PRIMARY KEY (player_id, match_id, minute)
);

CREATE TABLE IF NOT EXISTS PlayerNominedBD (
    player_id INTEGER,
    year INTEGER,
    position INTEGER
);

CREATE TABLE IF NOT EXISTS PlayerAssist (
    player_id INTEGER,
    match_id INTEGER,
    minute INTEGER,
    PRIMARY KEY (player_id, match_id, minute)
);

CREATE TABLE IF NOT EXISTS Transfer (
    transfer_id SERIAL PRIMARY KEY,
    from_club_id INTEGER,
    acquiring_club_id INTEGER,
    player_id INTEGER,
    cost DECIMAL,
    date DATE
);
