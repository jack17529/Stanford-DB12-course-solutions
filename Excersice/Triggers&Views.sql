/* Q1
(1/1 point)
Write an instead-of trigger that enables updates to the title attribute of view LateRating.

Policy: Updates to attribute title in LateRating should update Movie.title for the corresponding movie. (You may assume attribute mID is a key for table Movie.) Make sure the mID attribute of view LateRating has not also been updated -- if it has been updated, don't make any changes. Don't worry about updates to stars or ratingDate.

    Remember you need to use an instead-of trigger for view modifications as supported by SQLite. 
*/

1 create trigger R1
2 instead of update on LateRating
3 for each row
4 begin
5 update Movie
6 set title = new.title
7 where mID = new.mID;
8 end;


/*  Q2
(1/1 point)
Write an instead-of trigger that enables updates to the stars attribute of view LateRating.

Policy: Updates to attribute stars in LateRating should update Rating.stars for the corresponding movie rating. (You may assume attributes [mID,ratingDate] together are a key for table Rating.) Make sure the mID and ratingDate attributes of view LateRating have not also been updated -- if either one has been updated, don't make any changes. Don't worry about updates to title.

    Remember you need to use an instead-of trigger for view modifications as supported by SQLite.
*/

create trigger R2
instead of update on LateRating
for each row
begin     
    update Rating
    set stars = New.stars
    where mID = New.mID and ratingDate = New.ratingDate;
end;



/* Q3
(1/1 point)
Write an instead-of trigger that enables updates to the mID attribute of view LateRating.

Policy: Updates to attribute mID in LateRating should update Movie.mID and Rating.mID for the corresponding movie. Update all Rating tuples with the old mID, not just the ones contributing to the view. Don't worry about updates to title, stars, or ratingDate.

    Remember you need to use an instead-of trigger for view modifications as supported by SQLite.
*/

create trigger R3
instead of update of mID on LateRating
for each row
begin
  update Movie
  set mID = New.mID
  where mID = Old.mID;

  update Rating
  set mID = New.mID
  where mID = Old.mID;
end;



/* Q4
(1/1 point)
Finally, write a single instead-of trigger that combines all three of the previous triggers to enable simultaneous updates to attributes mID, title, and/or stars in view LateRating. Combine the view-update policies of the three previous problems, with the exception that mID may now be updated. Make sure the ratingDate attribute of view LateRating has not also been updated -- if it has been updated, don't make any changes.

    Remember you need to use an instead-of trigger for view modifications as supported by SQLite. 
*/

create trigger R4
instead of update on LateRating
for each row
when(old.ratingDate = new.ratingDate)
begin 
    update Rating
    set mID = New.mID
    where mID = Old.mID;
    update Rating
    set stars = New.stars
    where mID = New.mID and ratingDate = New.ratingDate;
    update Movie
    set title = new.title,mID = new.mID
    where mID = old.mID;
 end;
    


/* Q5
(1/1 point)
Write an instead-of trigger that enables deletions from view HighlyRated.

Policy: Deletions from view HighlyRated should delete all ratings for the corresponding movie that have stars > 3.

    Remember you need to use an instead-of trigger for view modifications as supported by SQLite. 
*/

create trigger R5
instead of delete on HighlyRated
for each row
begin 
    delete from Rating
    where mID = Old.mID
    and stars>3;
end;



/* Q6
(1/1 point)
Write an instead-of trigger that enables deletions from view HighlyRated.

Policy: Deletions from view HighlyRated should update all ratings for the corresponding movie that have stars > 3 so they have stars = 3.

    Remember you need to use an instead-of trigger for view modifications as supported by SQLite. 
*/

create trigger R6
instead of delete on HighlyRated
for each row 
begin
    update Rating
    set stars = 3
    where mID = Old.mID
    and stars>3;
end;



/* Q7
(1/1 point)
Write an instead-of trigger that enables insertions into view HighlyRated.

Policy: An insertion should be accepted only when the (mID,title) pair already exists in the Movie table. (Otherwise, do nothing.) Insertions into view HighlyRated should add a new rating for the inserted movie with rID = 201, stars = 5, and NULL ratingDate.

    Remember you need to use an instead-of trigger for view modifications as supported by SQLite. 
*/

create trigger R7
instead of insert on HighlyRated
for each row 
when New.mID in (select mID from Movie) and New.title in (select title from Movie)
begin
    insert into Rating values(201, New.mID, 5, Null);
end;



/*  Q8
(1/1 point)
Write an instead-of trigger that enables insertions into view NoRating.

Policy: An insertion should be accepted only when the (mID,title) pair already exists in the Movie table. (Otherwise, do nothing.) Insertions into view NoRating should delete all ratings for the corresponding movie.

    Remember you need to use an instead-of trigger for view modifications as supported by SQLite. 
*/

create trigger R8
instead of insert on NoRating
for each row
when New.mID in (select mID from Movie) and New.title in (select title from Movie)
begin
    delete from Rating
    where mID = New.mID;
end;



/* Q9
(1/1 point)
Write an instead-of trigger that enables deletions from view NoRating.

Policy: Deletions from view NoRating should delete the corresponding movie from the Movie table.

    Remember you need to use an instead-of trigger for view modifications as supported by SQLite. 
*/

create trigger R9
instead of delete on NoRating
for each row
begin
    delete from Movie
    where mID = Old.mID;
end;



/* Q10
(1/1 point)
Write an instead-of trigger that enables deletions from view NoRating.

Policy: Deletions from view NoRating should add a new rating for the deleted movie with rID = 201, stars = 1, and NULL ratingDate.

    Remember you need to use an instead-of trigger for view modifications as supported by SQLite. 
*/

create trigger R10
instead of delete on NoRating
for each row
when old.mID in (select mID from Movie)
begin
    insert into Rating values(201, old.mID, 1, Null);
end;
