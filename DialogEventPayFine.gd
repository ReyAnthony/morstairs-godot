extends DialogEvent
class_name DialogEventPayFine

func execute():
	if PlayerDataSingleton.can_pay_bounty():
		PlayerDataSingleton.pay_bounty()
		$"../CanvasLayer/DialogPanel".my_popup($"../".chara_name, $"../".chara_portrait, $CanPay)
	else:
		$"../CanvasLayer/DialogPanel".my_popup($"../".chara_name, $"../".chara_portrait, $CantPay)