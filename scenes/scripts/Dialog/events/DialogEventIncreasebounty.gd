extends DialogEvent
class_name DialogEventIncreaseBounty

func execute():
	PDS.increment_bounty(10)
