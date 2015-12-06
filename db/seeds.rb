p1 = Person.create(name: 'Vasiliy Pupkin')
n1 = Note.create(person: p1, type: 'decision', value: "Let's hire him")
n2 = Note.create(person: p1, type: 'expected_salary', value: "500")