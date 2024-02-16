class_name Signals

var signals: Array[Signal]


func _init(signals: Array[Signal] = []):
	self.signals = signals


func append(sig: Signal) -> Signals:
	signals.append(sig)
	return self


func remove(sig: Signal) -> Signals:
	signals.filter(func(s: Signal): return s != sig)
	return self


func await_all():
	await Signals.await_for(signals)


static func await_for(signals: Array[Signal]):
	var counter = Counter.new(signals.size())
	for sig in signals:
		sig.connect(func(_name): counter.increase())
	await counter.limit_reached
