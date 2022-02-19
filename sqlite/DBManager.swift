//
//  DBManager.swift
//  sqlite
//
//  Created by Mohamed Kamal on 13/02/2022.
//

import Foundation
import SQLite3
class DBManger
{
    private var fileUrl : URL?
    private var path : String?
    private var db : OpaquePointer?
    private var createTablePointer : OpaquePointer?
    private var insertStatmentPointer : OpaquePointer?
    private var readStatmentPointer : OpaquePointer?
    private var updateStatmentPointer : OpaquePointer?
    private var deleteStatmentPointer : OpaquePointer?
    static let sharedObject = DBManger()
    
    var names = [String]()
    var phones = [String]()
    var images = [String]()
    var ages = [String]()
    private init()
    {
        self.openConnection()
        print("open connection")
    }
    private func openConnection()
    {
        fileUrl = try? FileManager.default.url(for: .documentDirectory, in:.userDomainMask , appropriateFor: nil, create: true)
        path = fileUrl?.appendingPathComponent("swift.sqlite").relativePath
        if sqlite3_open(path, &db) == SQLITE_OK
        {
            self.createTable()
        }
        else
        {
            print("DB not opened")
        }
    }
    
    private func createTable()
    {
        let createTable = "CREATE TABLE IF NOT EXISTS FRIENDS (PHONE DOUBLE PRIMARY KEY NOT NULL ,NAME CHAR(255),AGE INT,IMAGE CHAR(255));"
        if sqlite3_prepare_v2(db,createTable, -1,&createTablePointer, nil) == SQLITE_OK
        {
            print("Friends table prepared")
            if sqlite3_step(createTablePointer) == SQLITE_DONE
            {
                print("Friends table created")
            }
            else
            {
                print("Friends table not created")
            }
        }
        else
        {
            print("Friends table not prepared")
        }
        sqlite3_finalize(createTablePointer)
    }
    
    func readQuery()
    {
        
        names.removeAll()
        phones.removeAll()
        images.removeAll()
        ages.removeAll()
        let readStatment = "SELECT * FROM FRIENDS"
        if( sqlite3_prepare_v2(db, readStatment, -1, &readStatmentPointer, nil) == SQLITE_OK )
        {
            while sqlite3_step(readStatmentPointer) == SQLITE_ROW
            {

                phones.append(String(cString:sqlite3_column_text(readStatmentPointer!, 0)))
                names.append(String(cString:sqlite3_column_text(readStatmentPointer!, 1)))
                ages.append(String(cString:sqlite3_column_text(readStatmentPointer!, 2)))
                images.append(String(cString:sqlite3_column_text(readStatmentPointer!, 3)))
                
            }
                                
        }
        else
        {
            print("readData: Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(db) as Any )
        }
        sqlite3_finalize(readStatmentPointer)
    }
    
    func insertQuery(name: String,phone: String,image: String,age: String)
    {
        let insertStatment = "INSERT INTO FRIENDS (PHONE,NAME,AGE,IMAGE) VALUES (?,?,?,?)"
        if( sqlite3_prepare_v2(db, insertStatment, -1, &insertStatmentPointer, nil) == SQLITE_OK )
        {
            sqlite3_bind_double(insertStatmentPointer!, 1, Double(phone)!)
            sqlite3_bind_text(insertStatmentPointer!, 2,name, -1, nil);
            sqlite3_bind_int(insertStatmentPointer!, 3, Int32(age)!)
            sqlite3_bind_text(insertStatmentPointer!, 4,image, -1, nil);
            sqlite3_step(insertStatmentPointer);
            
        }
        else
        {
            print("SaveBody: Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(db) as Any )
        }
        sqlite3_finalize(insertStatmentPointer)
    }
    
    func updateQuery(name: String,phone: String,age: String,oldPhone: String)
    {
        let updateStatment = "UPDATE FRIENDS SET NAME = '\(name)',PHONE='\(phone)',AGE='\(age)' WHERE PHONE='\(oldPhone)'"
        if( sqlite3_prepare_v2(db, updateStatment, -1, &updateStatmentPointer, nil) == SQLITE_OK )
        {
            if sqlite3_step(updateStatmentPointer) == SQLITE_DONE
            {
                print("update done")
            }
                                
        }
        else
        {
            print("updateData: Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(db) as Any )
        }
        sqlite3_finalize(updateStatmentPointer)
    }
    func deleteQuery(phone: String)
    {
        let deleteStatment = "DELETE FROM FRIENDS WHERE PHONE='\(phone)'"
        if( sqlite3_prepare_v2(db, deleteStatment, -1, &deleteStatmentPointer, nil) == SQLITE_OK )
        {
            if sqlite3_step(deleteStatmentPointer) == SQLITE_DONE
            {
                print("delete done")
            }
                                
        }
        else
        {
            print("deleteData: Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(db) as Any )
        }
        sqlite3_finalize(deleteStatmentPointer)
    }
    func closeConnection()
    {
        sqlite3_close(db)
        print("Connection Closed")
    }

}
