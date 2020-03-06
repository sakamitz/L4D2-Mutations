IncludeScript( "VSLib" );

MutationOptions <- {
	CommonLimit  = 0
	MegaMobSize  = 0
	WanderingZombieDensityModifier = 0
	MaxSpecials  = 30 // Max 30 SI at once, although the actual value will be far less
	TankLimit    = 5 // Up to 5 tanks
	WitchLimit   = 0
	BoomerLimit  = 30 // Up to 30 boomers
	ChargerLimit = 5
	HunterLimit  = 5
	JockeyLimit  = 5
	SpitterLimit = 5
	SmokerLimit  = 5
	SpecialRespawnInterval = 5  // Respawn a SI 5 seconds after it dies
	TotalSpecials = 25  // At least this many specials before director is done
	TotalBoomer = 15  // 15 boomers can spawn in a wave
}

::ArrSpecialInfectedWithWeight <- [
	Z_TANK,
	Z_CHARGER,
	Z_CHARGER,
	Z_HUNTER,
	Z_HUNTER,
	Z_JOCKEY,
	Z_JOCKEY,
	Z_SPITTER,
	Z_SPITTER,
	Z_SMOKER,
	Z_SMOKER
]


RoundVars.DidGetVomited <- false;
RoundVars.DuringRelax   <- false;
::BoomTimer  <- -1;
::RelaxTimer <- -1;


function Notifications::OnTankSpawned::ResetHealth(tank, params) {
	tank.SetHealth(2000);
}

// Relax for a short period after a mob
::Dropout <- function(params) {
	RoundVars.DidGetVomited <- false;
	RoundVars.DuringRelax   <- true;

	Timers.RemoveTimer(BoomTimer);
	RelaxTimer <- Timers.AddTimer(10.0, false, ResetRound);

	// Utils.SayToAll("Dropout was called.");
}

::ResetRound <- function(params) {
	Timers.RemoveTimer(RelaxTimer);
	RoundVars.DuringRelax <- false;
	// Utils.SayToAll("ResetRound was called.");
}

function Notifications::OnPlayerVomited::ChangeDidGetVomited(victim, boomer, params)
{
	if (RoundVars.DidGetVomited == false && RoundVars.DuringRelax == false)
	{
		RoundVars.DidGetVomited <- true;
		BoomTimer <- Timers.AddTimer(20.0, false, Dropout);

		// Utils.SayToAll("DidGetVomited was called.");
	}
}



// The following function will spawn either a boomer or another SI near a player
::SpawnInfectedQuickly <- function (params)
{
    // Don't spawn SI during relax time
    if (RoundVars.DuringRelax) {
        return;
    }

	foreach (player in Players.AliveSurvivors())
	{
		if (RoundVars.DidGetVomited) {
			SI <- Utils.GetRandValueFromArray(ArrSpecialInfectedWithWeight);
			Utils.SpawnZombieNearPlayer(player, SI, 800, 512);
		}
		else {
			Utils.SpawnZombieNearPlayer(player, Z_BOOMER, 800, 512);
        }
	}
}

// Start the timer when the player leaves the saferoom!
function Notifications::OnSurvivorsLeftStartArea::StartTheTimer()
{
	// Create the timer: (delay/interval, true to repeat, function to fire, optional param)
	Timers.AddTimer(5.0, true, SpawnInfectedQuickly);

	// Notify the players that the round has begun
	Utils.SayToAll("Boomer feast has begun!");
}
