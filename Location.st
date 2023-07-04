Object subclass: Location [
    | name n e s w items characters isOpened whatOpens description hint|

    Location class >> new [
        <category: 'instance creation'>
        | r |
        r := super new.
        r init.
        ^r
    ]

    init [
        characters := OrderedCollection new.
        items := OrderedCollection new.
        whatOpens := OrderedCollection new.
    ]

    "Print strings from array in separate lines."
    printItems [
        self getItems do: [ :a| Transcript show: '- '; show: a getName printString; cr ]
    ]

    printCharacters [
        self getCharacters do: [ :a| Transcript show: '- '; show: a getName printString; cr ]
    ]

    newCharacters: newCharacters [characters := newCharacters]

    getCharacters [^characters.]

    newDescription: newDescription [description := newDescription]

    getDescription [^description.]

    newHint: newHint [hint := newHint]

    getHint [^hint.]

    newName: newName [name := newName]

    getName [^name.]

    newN: newN [n := newN.]

    newE: newE [e := newE.]

    newS: newS [s := newS.]

    newW: newW [w := newW.]

    getN [^n.]

    getE [^e.]

    getS [^s.]

    getW [^w.]

    getIsOpened [^isOpened.]

    newIsOpened: newIsOpened [isOpened := newIsOpened.] 

    getWhatOpens [^whatOpens.]

    newWhatOpens: newWhatOpens [whatOpens := newWhatOpens.]

    getItems [^items.]

    newItems: newItems [items := newItems.]

    getSearchableItem: item [
        self getItems do: [ 
            :a| (a getName = item) & a getIsOpenable ifTrue: [
                ^a.
            ].
        ].
        ^nil.
    ]

    getItem: item [
        self getItems do: [ 
            :a| (a getName = item) & a getCanTake ifTrue: [
                ^a.
            ]
            ifFalse: [
                (a getIsOpenable) & (a getIsOpened) ifTrue: [
                    (a checkIfItemInsideItem: item) ifTrue: [
                        ^ a getItemInsideItem: item.
                    ]
                ] 
            ]].
        ^ nil.
        ]

    removeItem: item [
        self getItems remove: item ifAbsent: [
            self getItems do: [ 
                :a| (a checkIfItemInsideItem: item getName) ifTrue: [
                    a getItems remove: item.
                ]].
        ].
    ]
]
