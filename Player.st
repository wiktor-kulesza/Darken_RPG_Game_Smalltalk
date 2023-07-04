Object subclass: Player [
    | currentLocation inventory |
    <comment:
        'I represent a place to deposit and withdraw money'>
    Player class >> new [
        <category: 'instance creation'>
        | r |
        r := super new.
        r init.
        ^r
    ]

    init [
        inventory := OrderedCollection new.
    ]

    "Print items from inventory in separate lines."
    printInventory [
        self getInventory isNil ifFalse: [
            self getInventory do: [ :a| Transcript show: '- '; show: a getName printString; cr ].
        ]
        ifTrue: [
            Transcript show: 'You dont have any items'; cr.
        ]
    ]

    newIsAlive: newIsAlive [isAlive := newIsAlive.]

    getIsAlive [^isAlive.]

    newInventory: newInventory [inventory := newInventory.]

    getInventory [^inventory.]

    addItem: item [self getInventory add: item.]

    canGo: location [
        |equipmentSet|
        equipmentSet := self getInventory asSet.
        (location getWhatOpens ~= nil) & (location getWhatOpens size > 0) ifTrue: [
            location getWhatOpens do: [ 
                :a| (equipmentSet includes: a) ifFalse: [
                    ^false.
                ]
            ].
        ].
        ^true.
    ]

    goTo: location [
        (self canGo: location) ifTrue: [
            self newLocation: location.
            ^true.
        ]
        ifFalse: [
            Transcript show: 'You dont have items to unlock '; show: location getName; cr.
            (location getHint isNil) ifFalse: [
                Transcript show: location getHint; cr.
            ]. 
            ^false.
        ]
    ]

    checkIfItemInInventory: item [
        self getInventory do: [ 
            :a| a getName = item ifTrue: [
                ^true
            ]
        ].
        ^false.
    ]

    newLocation: newLocation [currentLocation := newLocation.]

    getLocation [^currentLocation.]

    goN [
        (self getLocation ~= nil) & (currentLocation getN ~= nil) 
            ifTrue: [self newLocation: self getLocation getN.].
    ]

    goE [
        (self getLocation ~= nil) & (currentLocation getE ~= nil) 
            ifTrue: [self newLocation: self getLocation getE.].
    ]

    goS [
        (self getLocation ~= nil) & (self getLocation getS ~= nil) 
            ifTrue: [self newLocation: self getLocation getS.].
    ]

    goW [
        (self getLocation ~= nil) & (self getLocation getW ~= nil) 
            ifTrue: [self newLocation: self getLocation getW.]
    ]

    printLocation [
        Transcript show: self getLocation getName printString.
        Transcript cr.
    ]
]