"
The and-predicate, a parser that succeeds whenever its delegate does, but does not consume the input stream [Parr 1994, 1995].
"
Class {
	#name : #PPAndParser,
	#superclass : #PPDelegateParser,
	#category : #'PetitParser-Parsers'
}

{ #category : #operators }
PPAndParser >> and [
	^ self
]

{ #category : #parsing }
PPAndParser >> parseOn: aStream [
	| element position |
	position := aStream position.
	element := parser parseOn: aStream.
	aStream position: position.
	^ element
]