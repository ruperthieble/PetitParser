Class {
	#name : #PPBrowserStream,
	#superclass : #PPStream,
	#instVars : [
		'positions',
		'stamps',
		'parsers'
	],
	#category : #'PetitGui-Core'
}

{ #category : #converting }
PPBrowserStream >> asFrequencyTable [
	| bag total result |
	bag := parsers asBag.
	total := 100.0 / bag size.
	result := OrderedCollection new.
	bag sortedCounts 
		do: [ :each | result addLast: (Array with: each value with: each key with: total * each key) ].
	^ result
]

{ #category : #converting }
PPBrowserStream >> asPositionMorph [
	| canvas stream morph |
	canvas := FormCanvas extent: self size + 1 @ self positions size.
	self contents keysAndValuesDo: [ :index :char |
		char isSeparator 
			ifFalse: [ canvas line: index @ 1 to: index @ canvas form height color: Color paleBlue ] ].
	self positions keysAndValuesDo: [ :index :position |
		canvas form colorAt: position @ index put: Color black ].
	morph := canvas form asMorph.
	morph 
		on: #mouseDown
		send: #mouseDown:with:
		to: self.
	^ morph
]

{ #category : #converting }
PPBrowserStream >> asTimingTable [
	| bag total result |
	bag := Bag new.
	1 to: stamps size - 1 do: [ :index |
		bag
			add: (parsers at: index) 
			withOccurrences: (stamps at: index + 1) - (stamps at: index) ].
	total := stamps last - stamps first.
	result := OrderedCollection new.
	bag sortedCounts
		do: [ :each | result addLast: (Array with: each value with: each key with: total * each key) ].
	^ result
]

{ #category : #private }
PPBrowserStream >> mouseDown: anEvent with: aMorph [
	| location string parser |
	location := anEvent position.
	string := collection 
		copyFrom: (location x - 5 min: collection size max: 1) 
		to: (location x + 5 min: collection size max: 1).
	parser := parsers at: location y.
	Transcript 
		show: string printString; cr;
		show: parser displayName; cr;
		cr
]

{ #category : #accessing }
PPBrowserStream >> next [
	| result |
	result := super next.
	self step.
	^ result
]

{ #category : #accessing }
PPBrowserStream >> next: aNumber [
	| result |
	result := super next: aNumber.
	self step.
	^ result
]

{ #category : #information }
PPBrowserStream >> parsers [
	^ parsers
]

{ #category : #positioning }
PPBrowserStream >> position: aNumber [
	super position: aNumber.
	self step
]

{ #category : #information }
PPBrowserStream >> positions [
	^ positions
]

{ #category : #positioning }
PPBrowserStream >> reset [
	super reset.
	positions := OrderedCollection new: 1024.
	stamps := OrderedCollection new: 1024.
	parsers := OrderedCollection new: 1024
]

{ #category : #information }
PPBrowserStream >> stamps [
	^ stamps
]

{ #category : #private }
PPBrowserStream >> step [
	positions addLast: position.
	stamps addLast: Time millisecondClockValue.
	parsers addLast: thisContext sender sender receiver
]