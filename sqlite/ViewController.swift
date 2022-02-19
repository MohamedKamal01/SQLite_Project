//
//  ViewController.swift
//  sqlite
//
//  Created by Mohamed Kamal on 13/02/2022.
//

import UIKit
import SQLite3
class ViewController: UIViewController {

    @IBOutlet weak var id: UITextField!
    @IBOutlet weak var name: UITextField!
    var fileUrl : URL?
    var path : String?
    var db : OpaquePointer?
    var createTablePointer : OpaquePointer?
    var insertStatmentPointer : OpaquePointer?
    var readStatmentPointer : OpaquePointer?
    var updateStatmentPointer : OpaquePointer?
    var deleteStatmentPointer : OpaquePointer?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        fileUrl = try? FileManager.default.url(for: .documentDirectory, in:.userDomainMask , appropriateFor: nil, create: true)
        path = fileUrl?.appendingPathComponent("swift.sqlite").relativePath
        //print(path)
        if sqlite3_open(path, &db) == SQLITE_OK
        {
            let createTable = "CREATE TABLE CONTACT (ID INT PRIMARY KEY NOT NULL ,NAME CHAR(255));"
            if sqlite3_prepare_v2(db,createTable, -1,&createTablePointer, nil) == SQLITE_OK
            {
                print("contact table prepared")
                if sqlite3_step(createTablePointer) == SQLITE_DONE
                {
                    print("contact table created")
                }
                else
                {
                    print("contact table not created")
                }
            }
            else
            {
                print("contact table not prepared")
            }
        }
        else
        {
            print("DB not opened")
        }
    }

    @IBAction func save(_ sender: Any) {
        if sqlite3_open(path, &db) == SQLITE_OK
        {
            let insertStatment = "INSERT INTO CONTACT (ID,NAME) VALUES (?,?)"
            if( sqlite3_prepare_v2(db, insertStatment, -1, &insertStatmentPointer, nil) == SQLITE_OK )
            {

                sqlite3_bind_int(insertStatmentPointer!, 1, Int32(id.text!)!)
                sqlite3_bind_text(insertStatmentPointer!, 2,(name.text!), -1, nil);
                sqlite3_step(insertStatmentPointer);
                name.text = ""
                id.text = ""
            }
            else
            {
                print("SaveBody: Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(db) as Any )
            }
            sqlite3_finalize(insertStatmentPointer)

        }
    }
    
    @IBAction func del(_ sender: Any) {
        if sqlite3_open(path, &db) == SQLITE_OK
        {
            let deleteStatment = "DELETE FROM CONTACT"
            if( sqlite3_prepare_v2(db, deleteStatment, -1, &deleteStatmentPointer, nil) == SQLITE_OK )
            {
                while sqlite3_step(deleteStatmentPointer) == SQLITE_DONE
                {
                   
                    print("delete done")
                    name.text = ""
                    id.text = ""
                }
                                    
            }
            else
            {
                print("deleteData: Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(db) as Any )
            }
            sqlite3_finalize(deleteStatmentPointer)

        }
    }
    @IBAction func update(_ sender: Any) {
        if sqlite3_open(path, &db) == SQLITE_OK
        {
            let updateStatment = "UPDATE CONTACT SET NAME = 'NADER' WHERE ID = '1'"
            if( sqlite3_prepare_v2(db, updateStatment, -1, &updateStatmentPointer, nil) == SQLITE_OK )
            {
                if sqlite3_step(updateStatmentPointer) == SQLITE_DONE
                {
                    id.text = String(sqlite3_column_int(readStatmentPointer!, 0))

                    name.text = String(cString:sqlite3_column_text(readStatmentPointer!, 1))
                    print("update done")
                }
                                    
            }
            else
            {
                print("updateData: Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(db) as Any )
            }
            sqlite3_finalize(updateStatmentPointer)

        }
    }
    @IBAction func read(_ sender: Any) {
        if sqlite3_open(path, &db) == SQLITE_OK
        {
            let readStatment = "SELECT * FROM CONTACT"
            if( sqlite3_prepare_v2(db, readStatment, -1, &readStatmentPointer, nil) == SQLITE_OK )
            {
                while sqlite3_step(readStatmentPointer) == SQLITE_ROW
                {
                    id.text = String(sqlite3_column_int(readStatmentPointer!, 0))

                    name.text = String(cString:sqlite3_column_text(readStatmentPointer!, 1))
                }
                                    
            }
            else
            {
                print("readData: Failed from sqlite3_prepare_v2. Error is:  %s", sqlite3_errmsg(db) as Any )
            }
            sqlite3_finalize(readStatmentPointer)

        }
    }
}

