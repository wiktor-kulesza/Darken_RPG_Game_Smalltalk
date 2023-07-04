
Object subclass: CharacterInGame [
    | isAlive name |
    
    CharacterInGame class >> new [
        <category: 'instance creation'>
        | r |
        r := super new.
        r init.
        ^r
    ]

    init [
        self newIsAlive: true.
    ]


    newIsAlive: newIsAlive [isAlive := newIsAlive.]

    getIsAlive [^isAlive.]

    getName [^name.]

    newName: newName [name := newName]
]
