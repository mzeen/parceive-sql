CREATE TABLE Access(
  Id INTEGER PRIMARY KEY NOT NULL,
  Instruction INTEGER,
  Position INTEGER,
  Reference INTEGER,
  Type INTEGER,
  State INTEGER,
  Address INTEGER,
  Size INTEGER,
  FOREIGN KEY(Reference) REFERENCES Reference(Id),
  FOREIGN KEY(Instruction) REFERENCES Instruction(Id)
);

CREATE TABLE Call(
  Id INTEGER PRIMARY KEY NOT NULL,
  Thread INTEGER,
  Function INTEGER,
  Instruction INTEGER,
  Start INTEGER,
  End INTEGER,
  FOREIGN KEY(Thread) REFERENCES Thread(Id),
  FOREIGN KEY(Function) REFERENCES Function(Id),
  FOREIGN KEY(Instruction) REFERENCES Instruction(Id)
);

CREATE TABLE Conflict(
  Id INTEGER PRIMARY KEY NOT NULL,
  TagInstance1 INTEGER,
  TagInstance2 INTEGER,
  Access1 INTEGER,
  Access2 INTEGER,
  FOREIGN KEY(TagInstance1) REFERENCES TagInstance(Id),
  FOREIGN KEY(TagInstance2) REFERENCES TagInstance(Id),
  FOREIGN KEY(Access1) REFERENCES Access(Id),
  FOREIGN KEY(Access2) REFERENCES Access(Id)
);

CREATE TABLE File(
  Id INTEGER PRIMARY KEY NOT NULL,
  Path VARCHAR,
  Image INTEGER,
  FOREIGN KEY(Image) REFERENCES Image(Id)
);

CREATE TABLE Function(
  Id INTEGER PRIMARY KEY NOT NULL,
  Name VARCHAR,
  Prototype VARCHAR,
  Type INTEGER,
  File INTEGER,
  Line INTEGER,
  FOREIGN KEY(File) REFERENCES File(Id),
  CONSTRAINT UniqueFunction UNIQUE (Name, Prototype, File, Line)
);

CREATE TABLE Image (
    Id INTEGER PRIMARY KEY NOT NULL,
    Name VARCHAR
);

CREATE TABLE Instruction(
  Id INTEGER PRIMARY KEY NOT NULL,
  Segment INTEGER,
  Type INTEGER,
  Line INTEGER,
  FOREIGN KEY(Segment) REFERENCES Segment(Id)
);

CREATE TABLE InstructionTagInstance(
  Id INTEGER PRIMARY KEY NOT NULL,
  Instruction INTEGER,
  Tag INTEGER,
  FOREIGN KEY(Instruction) REFERENCES Instruction(Id),
  FOREIGN KEY(Tag) REFERENCES Tag(Id)
);

CREATE TABLE Loop(
  Id INTEGER PRIMARY KEY NOT NULL,
  Line INTEGER
);

CREATE TABLE LoopExecution(
  Id INTEGER PRIMARY KEY NOT NULL,
  Loop INTEGER,
  ParentIteration INTEGER,
  Start INTEGER,
  End INTEGER,
  FOREIGN KEY(Loop) REFERENCES Loop(Id),
  FOREIGN KEY(ParentIteration) REFERENCES LoopIteration(Id)
);

CREATE TABLE LoopIteration(
  Id INTEGER PRIMARY KEY NOT NULL,
  Execution INTEGER,
  Iteration INTEGER,
  FOREIGN KEY(Execution) REFERENCES LoopExecution(Id)
);

CREATE TABLE Member(
  Id INTEGER PRIMARY KEY NOT NULL,
  Name VARCHAR
);

CREATE TABLE Reference(
  Id INTEGER PRIMARY KEY NOT NULL,
  Size INTEGER,
  Type INTEGER,
  Name VARCHAR,
  Allocator INTEGER,
  Deallocator INTEGER,
  Member INTEGER,
  FOREIGN KEY(Allocator) REFERENCES Instruction(Id),
  FOREIGN KEY(Deallocator) REFERENCES Instruction(Id),
  FOREIGN KEY(Member) REFERENCES Member(Id)
);

CREATE TABLE Segment(
  Id INTEGER PRIMARY KEY NOT NULL,
  Call INTEGER,
  Type INTEGER,
  LoopIteration INTEGER,
  FOREIGN KEY(Call) REFERENCES Call(Id),
  FOREIGN KEY(LoopIteration) REFERENCES LoopIteration(Id)
);

CREATE TABLE SourceLocation(
  Id INTEGER PRIMARY KEY NOT NULL,
  Function INTEGER,
  Line INTEGER,
  Column INTEGER,
  FOREIGN KEY(Function) REFERENCES File(Id),
  CONSTRAINT UniqueSourceLocation UNIQUE (Function, Line, Column)
);

CREATE TABLE Tag (
  Id INTEGER PRIMARY KEY NOT NULL,
  Name VARCHAR,
  Type INTEGER
);

CREATE TABLE TagHit(
  Id INTEGER PRIMARY KEY NOT NULL,
  TSC INTEGER,
  TagInstruction INTEGER,
  Thread INTEGER,
  FOREIGN KEY(Thread) REFERENCES Thread(Id),
  FOREIGN KEY(TagInstruction) REFERENCES TagInstruction(Id),
  CONSTRAINT UniqueTagHitTime UNIQUE (TSC)
);

CREATE TABLE TagInstance(
  Id INTEGER PRIMARY KEY NOT NULL,
  Tag INTEGER,
  Start INTEGER,
  End INTEGER,
  Thread INTEGER,
  Counter INTEGER,
  FOREIGN KEY(Thread) REFERENCES Thread(Id),
  FOREIGN KEY(Tag) REFERENCES Tag(Id)
);

CREATE TABLE TagInstruction(
  Id INTEGER PRIMARY KEY NOT NULL,
  Tag INTEGER,
  Location INTEGER,
  Type INTEGER,
  FOREIGN KEY(Location) REFERENCES SourceLocation(Id),
  FOREIGN KEY(Tag) REFERENCES Tag(Id),
  CONSTRAINT UniqueTagInstruction UNIQUE (Tag, Location, Type)
);

CREATE TABLE Thread(
  Id INTEGER PRIMARY KEY NOT NULL,
  Call INTEGER,
  CreateInstruction INTEGER,
  JoinInstruction INTEGER,
  Process INTEGER,
  StartTime VARCHAR,
  EndTSC INTEGER,
  EndTime VARCHAR,
  Parent INTEGER,
  FOREIGN KEY(Call) REFERENCES Call(Id),
  FOREIGN KEY(CreateInstruction) REFERENCES Instruction(Id),
  FOREIGN KEY(JoinInstruction) REFERENCES Instruction(Id)
);
