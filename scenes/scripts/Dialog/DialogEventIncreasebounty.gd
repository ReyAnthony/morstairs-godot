extends DialogEvent
class_name DialogEventIncreaseBounty

func execute():
	PlayerDataSingleton.increment_bounty(10)
