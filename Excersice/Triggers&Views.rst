 Q1
(1/1 point)
Write an instead-of trigger that enables updates to the title attribute of view LateRating.

Policy: Updates to attribute title in LateRating should update Movie.title for the corresponding movie. (You may assume attribute mID is a key for table Movie.) Make sure the mID attribute of view LateRating has not also been updated -- if it has been updated, don't make any changes. Don't worry about updates to stars or ratingDate.

    Remember you need to use an instead-of trigger for view modifications as supported by SQLite. 
::

1 create trigger R1
2 instead of update on LateRating
3 for each row
4 begin
5 update Movie
6 set title = new.title
7 where mID = new.mID;
8 end;


