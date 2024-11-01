import Buffer "mo:base/Buffer";
import D "mo:base/Debug";
import ExperimentalCycles "mo:base/ExperimentalCycles";

import Principal "mo:base/Principal";
import Time "mo:base/Time";

import CertifiedData "mo:base/CertifiedData";
import CertTree "mo:cert/CertTree";

import ICRC1 "mo:icrc1-mo/ICRC1";
import ICRC2 "mo:icrc2-mo/ICRC2";
import ICRC3 "mo:icrc3-mo/";
import ICRC4 "mo:icrc4-mo/ICRC4";

shared ({ caller = _owner }) actor class Token  (args: ?{
    icrc1 : ?ICRC1.InitArgs;
    icrc2 : ?ICRC2.InitArgs;
    icrc3 : ICRC3.InitArgs; //already typed nullable
    icrc4 : ?ICRC4.InitArgs;
  }
) = this{

    let default_icrc1_args : ICRC1.InitArgs = {
      name = ?"Waste2Earn";
      symbol = ?"W2EN";
      logo = ?"data:image/png;base64,iVBORw0KGgoAAAANSUhEUgAAADAAAAAwCAYAAABXAvmHAAAACXBIWXMAAA7EAAAOxAGVKw4bAAAE6mlUWHRYTUw6Y29tLmFkb2JlLnhtcAAAAAAAPHg6eG1wbWV0YSB4bWxuczp4PSdhZG9iZTpuczptZXRhLyc+CiAgICAgICAgPHJkZjpSREYgeG1sbnM6cmRmPSdodHRwOi8vd3d3LnczLm9yZy8xOTk5LzAyLzIyLXJkZi1zeW50YXgtbnMjJz4KCiAgICAgICAgPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9JycKICAgICAgICB4bWxuczpkYz0naHR0cDovL3B1cmwub3JnL2RjL2VsZW1lbnRzLzEuMS8nPgogICAgICAgIDxkYzp0aXRsZT4KICAgICAgICA8cmRmOkFsdD4KICAgICAgICA8cmRmOmxpIHhtbDpsYW5nPSd4LWRlZmF1bHQnPndNKDQ4eDQ4KSAtIDE8L3JkZjpsaT4KICAgICAgICA8L3JkZjpBbHQ+CiAgICAgICAgPC9kYzp0aXRsZT4KICAgICAgICA8L3JkZjpEZXNjcmlwdGlvbj4KCiAgICAgICAgPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9JycKICAgICAgICB4bWxuczpBdHRyaWI9J2h0dHA6Ly9ucy5hdHRyaWJ1dGlvbi5jb20vYWRzLzEuMC8nPgogICAgICAgIDxBdHRyaWI6QWRzPgogICAgICAgIDxyZGY6U2VxPgogICAgICAgIDxyZGY6bGkgcmRmOnBhcnNlVHlwZT0nUmVzb3VyY2UnPgogICAgICAgIDxBdHRyaWI6Q3JlYXRlZD4yMDI0LTA0LTE4PC9BdHRyaWI6Q3JlYXRlZD4KICAgICAgICA8QXR0cmliOkV4dElkPmIyN2E1MzUyLTQ1M2MtNDhmMC1hZTZiLTllMjMwZDY5NDAwZjwvQXR0cmliOkV4dElkPgogICAgICAgIDxBdHRyaWI6RmJJZD41MjUyNjU5MTQxNzk1ODA8L0F0dHJpYjpGYklkPgogICAgICAgIDxBdHRyaWI6VG91Y2hUeXBlPjI8L0F0dHJpYjpUb3VjaFR5cGU+CiAgICAgICAgPC9yZGY6bGk+CiAgICAgICAgPC9yZGY6U2VxPgogICAgICAgIDwvQXR0cmliOkFkcz4KICAgICAgICA8L3JkZjpEZXNjcmlwdGlvbj4KCiAgICAgICAgPHJkZjpEZXNjcmlwdGlvbiByZGY6YWJvdXQ9JycKICAgICAgICB4bWxuczpwZGY9J2h0dHA6Ly9ucy5hZG9iZS5jb20vcGRmLzEuMy8nPgogICAgICAgIDxwZGY6QXV0aG9yPlJFUiBEQU88L3BkZjpBdXRob3I+CiAgICAgICAgPC9yZGY6RGVzY3JpcHRpb24+CgogICAgICAgIDxyZGY6RGVzY3JpcHRpb24gcmRmOmFib3V0PScnCiAgICAgICAgeG1sbnM6eG1wPSdodHRwOi8vbnMuYWRvYmUuY29tL3hhcC8xLjAvJz4KICAgICAgICA8eG1wOkNyZWF0b3JUb29sPkNhbnZhIChSZW5kZXJlcik8L3htcDpDcmVhdG9yVG9vbD4KICAgICAgICA8L3JkZjpEZXNjcmlwdGlvbj4KICAgICAgICAKICAgICAgICA8L3JkZjpSREY+CiAgICAgICAgPC94OnhtcG1ldGE+VBGT1AAAC2NJREFUeJzFWntwVNUd/s65d+/Nze5mE8j7QR4kCBJe4aUBEgRGHioGsANWWySItelQp7ZiGXVaHbU6joxUO52CGFpExD7AGaG0JGBJ4gt5JCGGPMgL8trNY8lms7v3dfrHJoFASO4GbL9/dmbP+c7v+51zfud3HpfgDiBWuG9aEI1cbOHiUwQamq0xTypjusSgcwBAQDVCOA9Hgmpk3XmqV7tS59XtJ1rkkxW3a5uMlWjlkiLSpMef4kjwT7vVC3EtvhPo09sMcYNpNGLFJQjj06+ozP2HWs/+PS6twTEWHQE7YOVSklKlDdv6tPbNDd5Dgo91jcXuIEQyDsnSWlmiUXtqPQfedGl1jYHwDTtg4SYIqdJjv1F017YqTz6vMnfgakcAT8y4S8pVTdT6Zq3nw5d7tSbFCM+QA3HC0mmx4tIDFe73pvbpLbendBQE01ikm7dWNPsKNjTLhRdGqz+qA9PMz/5IYa49F/t2m+6MRGOYHPyUIhDr5jL32/tGqseNVDjL8sKr3eqFHZe8B0es932gQznDiXR8Tor0A65NLjp5q3q3FJZheelNu/z19ivyv8a8Ut0urmrVhCdS9kTpUbFNPlU4XJ1hHZhp2f5Mt1LxymX56P9N/AB6tEsIouELE8XVHe1Kyekby29yIEFctViktgPVnr1jE08AcAQI4kGCBRCJB+EpwPrLWOBNOtVKEinMXyHSsFM9Wk3DjeYGYeEmSDPMz10q6dkaE7AVgQONtoJLDgONtgIhIgjPXRPtU6F3eaBVtEOr6Qi4eQKKzJCdraXutyb2ak2egf+HjMBU89Yd5e6dS1XWa7xlSkCTx0FYlAx+RgxotBVEMoFQeq17CACegpgF6I1OcFdlAABjgQwHQ6dy3jopeJOtTT71z5sciBWW3E3B5bcpRcanThAPPnMCTHPiQUJFgNJBY9ABMAbozP8LAD4VSlEDpk6egnfffRfh4eFwOp3o7u42ZE5hvbBxaXNEGvqJS2voAAB+oDAlaN22kp5n6K3pN0DiISxLBY0NAbh+mg4wnwK9tQf6lR6wXhlgDETkQcKDAVkDfCrsDgem3D0Va9esgcfjQUVFBQ4fPox/HDqE6urqEc3WePbRzJB3nmuRT24G+kfAyiXHE0I/6FTPG3OApzAtSwUXb/OLZwBkFWplO9TP66BV2MHsbjCnF+yqF6yzD/rlq9BbXAAAT18fVq5YibTUVAiCgNjYWGQvXozW1laUlJSMaJpBg0jHTVOY632ZOXspAKRKP9zY4D1sOFnx8+LBxV/X824ZckEt1OJGsB7fqHxd11FaVgpV1UAIASEEPp8PJwqHXepvQoP3U36i9OhGAKAAoDMlV2EuQ2QaawV/VwTA+/1lfQp8/66G3ug0xB/A2TNnISsydF0HAARLEl597TUQMnoIKqwHANsMADRGyE50afXJo5HIOAnc7Djwc+KAoP7Q0RnUrxrB2gJYtfpRUXEB9Q0NOF9WDk3zj8TSJUuQnZ1tiO9S6yfGCNlJVKJRD7bLX4zutqyBvzsCND4U6O8l1u2F1nQ1YPEAUF9fj5UrVmD7r59Hr9u/NSeEIC8vzxC/XSkhEo16gMaJS2a69eZRCcyrgjm915ZEACQsCKYZsYMOBQJZltHS0oKSL77A6W/PDE6lrEWLEBISMiq/V7uMeHHZLOrVOxYYsqjq0Dv7rm0FNB1qaSuU05eHOBUo+txuFBYch9o/jawhIZgyeYohrkfvyKSK7oo3akx3uAFN94s/3Qz168uAqo9Z/ABKS8ugKP4DmGAyITEx0RBP1q/GUR1KkFFDrNMD5lWgnGqAerbZn2VHQEbGbOzetQtWq3XEeg6HHbKsgBACSilCQ23G9ECTeHZdNh6V4PJBKbw0mJBGQkZGBg4cOICU5CSEhYXhyS1b4HTeYqklZEgYGd8jMZ4SGN89QNEgdilISEjAjOnTQenw3MzMTHz0kV88x3FYs2YN9ubnIzQ0dNj60VHRMJkEAICmabA7jN2wMACUgjMcgZtyc1FQWIjioiIcOXJk2Lm6YOFC7Nq1G6kpyeC4a8n9oYcewsGPP0Z4ePhNnNmzZ0Mw8WCMQZZl1NfXG9JDCa9TgIye+wfAGKZPn4H4+HhERkZi2bJlQzLn/PnzsftPuzB50iQQSqHrOrxeLxhj/kS1dCkOHjyIiIiIQY7VasX9y+8Hx/lnsqOjA1VVVcYcACdTgdqajOovLi6Gvb0dAMBxHLZs2QKbzR9wM2fNwr4PP0RaWioIJWCMofLiRfz25VfQbndA13VQSrE4Oxt//eSTQSdWrXqgfzoSMABHjx6Fz2esTwVia+JSpcdmNvo+zTBCcDqdSE+fhvT0qeA4DrExMZBlGYqiYv/+/UhOTByMi8rKSuSsWYMjRz5DZ1cX5s6dD4s5GJRSJCQkIPPee1FWXo6dO3+P6KhIEEIgyzK2bNkCh8EYSJMe/5TjSXCKwnpWyGz0LQFjDE1NjVj98MOwWq0gAObNnYucnBzExcSAUgrGGMrKyrB23TrU1dUBAEpLS+FwOJCZuQCSFASO45CQkID1GzYgOioSlPpjZW9+PvLz8w2Jt3JJUFnfB5xEI1w2flJet/qdIaLdbocgirhn3nyIogie52E2mwdjoaysDOvXr8elS5eG8MrLy9DU1Iis7GxIkgRCCERRHByx2tpabMrNhctlbFecIC6HV7c/y7m0Bkei+PDmNqXYWPYA8NWXXyI1LQ1pk9JgMvkv7BhjuHjxItauW4faG8QPoLKyEo2NjcjKyhridHdXFzY+8QTKy8uNSkBSUM7lGs++FzkAiBGzzZ1K6RIdxoKHMYaTJ08iOSUFycnJMJlMqKmuRk5ODmrrLoGmhIGfEw8aaQaNtoJOHA9+ahT0Nhe+K72AlpYW3DP/HlgsZjgcDvzk6adx7Ngxw+IFYkOkMO+tNrmoiAMAt3alLl5c/vMutdRwVvP5fCg4fhyU48DzPB7dsAG1dXWgSWEwLUoCjQ4BjQ0BjbOBRllAwiTwieOgXXbiwplzaG1rw/jwcOTl5eH48eOGxQPARGmD2uT7bJPMnD2Di/iCkPfe/7Ln2c065IAa43keFosVTmc36AQbTFlJIJYggA6zxdYZWLcX8rEqoMcHi8VieM4PgMKEzJB39hT3/OxJ4LprFY15LsYIWXmGD/YDmvqTlb91CiargNZ/laLp/t2qRwHr7oNW3w2tyg7W5QE0HbIcWGcBwCRpk9amFK/v1Rq6ges2ci3yyeqZlu07gmnMc316a8ANAwDr9kDr9kA73//UxBP/YUdlt3VmGEAwjUMwF72jyrNncJUY0tu1nv0vzrBsqw1ogzcSVAYo+h0RT0Ax0/J8TY1n3wvX/z/kKkVmVzXGtOIEcWWuQ/nmf/4mMBLSg7eqbXLx8k713JDz701d3SwXnKPEtDFRXH373XaHkCiuZoRwP26WC87dWDZsL9uVry6kSOsIh6DFLq3u+1c4AuLF+xFumvlKqfut94Yrv+U0aZOLPk+THpNEOn6hU734/SkcAclB6zDeNPN353pfe+lWdUac563yqYIkMacrUpi/3K58Tcb0OjEGEHCYbv6VLtHwrefdr78xUt1RA7VNKf5GoLbCdPMvVnYp561GryDHCjONxzzr642tyqlV1Z4/HxqtfgAP3YnWSdITb/RpzU9XefZSBvX2lN4khMNd0ibdzMX9scqzd3uv1miopwK+UosV7ps83jTrl17dsbHJe8R0Jz41mBD0oCLRiL90KOfebpFPVAbCv52PPSJjhftyg7nYR5xq1ax2uZga/9gjBtHCQt3GT/rWrTX/vVX+fK9La7CPRccdeUa1cIm2cFPGIyFcSrpAbVka86bd4nObWll3/qdHq7vQoZz9W6/WOLab4evwXwEMthdrWGYXAAAAAElFTkSuQmCC";
      decimals = 8;
      fee = ?#Fixed(10000);
      minting_account = ?{
        owner = _owner;
        subaccount = null;
      };
      max_supply = null;
      min_burn_amount = ?10000;
      max_memo = ?64;
      advanced_settings = null;
      metadata = null;
      fee_collector = null;
      transaction_window = null;
      permitted_drift = null;
      max_accounts = ?100000000;
      settle_to_accounts = ?99999000;
    };

    let default_icrc2_args : ICRC2.InitArgs = {
      max_approvals_per_account = ?10000;
      max_allowance = ?#TotalSupply;
      fee = ?#ICRC1;
      advanced_settings = null;
      max_approvals = ?10000000;
      settle_to_approvals = ?9990000;
    };

    let default_icrc3_args : ICRC3.InitArgs = ?{
      maxActiveRecords = 3000;
      settleToRecords = 2000;
      maxRecordsInArchiveInstance = 100000000;
      maxArchivePages = 62500;
      archiveIndexType = #Stable;
      maxRecordsToArchive = 8000;
      archiveCycles = 6_000_000_000_000;
      archiveControllers = null; //??[put cycle ops prinicpal here];
      supportedBlocks = [
        {
          block_type = "1xfer"; 
          url="https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3";
        },
        {
          block_type = "2xfer"; 
          url="https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3";
        },
        {
          block_type = "2approve"; 
          url="https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3";
        },
        {
          block_type = "1mint"; 
          url="https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3";
        },
        {
          block_type = "1burn"; 
          url="https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3";
        }
      ];
    };

    let default_icrc4_args : ICRC4.InitArgs = {
      max_balances = ?200;
      max_transfers = ?200;
      fee = ?#ICRC1;
    };

    let icrc1_args : ICRC1.InitArgs = switch(args){
      case(null) default_icrc1_args;
      case(?args){
        switch(args.icrc1){
          case(null) default_icrc1_args;
          case(?val){
            {
              val with minting_account = switch(
                val.minting_account){
                  case(?val) ?val;
                  case(null) {?{
                    owner = _owner;
                    subaccount = null;
                  }};
                };
            };
          };
        };
      };
    };

    let icrc2_args : ICRC2.InitArgs = switch(args){
      case(null) default_icrc2_args;
      case(?args){
        switch(args.icrc2){
          case(null) default_icrc2_args;
          case(?val) val;
        };
      };
    };


    let icrc3_args : ICRC3.InitArgs = switch(args){
      case(null) default_icrc3_args;
      case(?args){
        switch(args.icrc3){
          case(null) default_icrc3_args;
          case(?val) ?val;
        };
      };
    };

    let icrc4_args : ICRC4.InitArgs = switch(args){
      case(null) default_icrc4_args;
      case(?args){
        switch(args.icrc4){
          case(null) default_icrc4_args;
          case(?val) val;
        };
      };
    };

    stable let icrc1_migration_state = ICRC1.init(ICRC1.initialState(), #v0_1_0(#id),?icrc1_args, _owner);
    stable let icrc2_migration_state = ICRC2.init(ICRC2.initialState(), #v0_1_0(#id),?icrc2_args, _owner);
    stable let icrc4_migration_state = ICRC4.init(ICRC4.initialState(), #v0_1_0(#id),?icrc4_args, _owner);
    stable let icrc3_migration_state = ICRC3.init(ICRC3.initialState(), #v0_1_0(#id), icrc3_args, _owner);
    stable let cert_store : CertTree.Store = CertTree.newStore();
    let ct = CertTree.Ops(cert_store);


    stable var owner = _owner;

    let #v0_1_0(#data(icrc1_state_current)) = icrc1_migration_state;

    private var _icrc1 : ?ICRC1.ICRC1 = null;

    private func get_icrc1_state() : ICRC1.CurrentState {
      return icrc1_state_current;
    };

    private func get_icrc1_environment() : ICRC1.Environment {
    {
      get_time = null;
      get_fee = null;
      add_ledger_transaction = ?icrc3().add_record;
      can_transfer = null; //set to a function to intercept and add validation logic for transfers
    };
  };

    func icrc1() : ICRC1.ICRC1 {
    switch(_icrc1){
      case(null){
        let initclass : ICRC1.ICRC1 = ICRC1.ICRC1(?icrc1_migration_state, Principal.fromActor(this), get_icrc1_environment());
        ignore initclass.register_supported_standards({
          name = "ICRC-3";
          url = "https://github.com/dfinity/ICRC/ICRCs/icrc-3/"
        });
        ignore initclass.register_supported_standards({
          name = "ICRC-10";
          url = "https://github.com/dfinity/ICRC/ICRCs/icrc-10/"
        });
        _icrc1 := ?initclass;
        initclass;
      };
      case(?val) val;
    };
  };

  let #v0_1_0(#data(icrc2_state_current)) = icrc2_migration_state;

  private var _icrc2 : ?ICRC2.ICRC2 = null;

  private func get_icrc2_state() : ICRC2.CurrentState {
    return icrc2_state_current;
  };

  private func get_icrc2_environment() : ICRC2.Environment {
    {
      icrc1 = icrc1();
      get_fee = null;
      can_approve = null; //set to a function to intercept and add validation logic for approvals
      can_transfer_from = null; //set to a function to intercept and add validation logic for transfer froms
    };
  };

  func icrc2() : ICRC2.ICRC2 {
    switch(_icrc2){
      case(null){
        let initclass : ICRC2.ICRC2 = ICRC2.ICRC2(?icrc2_migration_state, Principal.fromActor(this), get_icrc2_environment());
        _icrc2 := ?initclass;
        initclass;
      };
      case(?val) val;
    };
  };

  let #v0_1_0(#data(icrc4_state_current)) = icrc4_migration_state;

  private var _icrc4 : ?ICRC4.ICRC4 = null;

  private func get_icrc4_state() : ICRC4.CurrentState {
    return icrc4_state_current;
  };

  private func get_icrc4_environment() : ICRC4.Environment {
    {
      icrc1 = icrc1();
      get_fee = null;
      can_approve = null; //set to a function to intercept and add validation logic for approvals
      can_transfer_from = null; //set to a function to intercept and add validation logic for transfer froms
    };
  };

  func icrc4() : ICRC4.ICRC4 {
    switch(_icrc4){
      case(null){
        let initclass : ICRC4.ICRC4 = ICRC4.ICRC4(?icrc4_migration_state, Principal.fromActor(this), get_icrc4_environment());
        _icrc4 := ?initclass;
        initclass;
      };
      case(?val) val;
    };
  };

  let #v0_1_0(#data(icrc3_state_current)) = icrc3_migration_state;

  private var _icrc3 : ?ICRC3.ICRC3 = null;

  private func get_icrc3_state() : ICRC3.CurrentState {
    return icrc3_state_current;
  };

  func get_state() : ICRC3.CurrentState{
    return icrc3_state_current;
  };

  private func get_icrc3_environment() : ICRC3.Environment {
    ?{
      updated_certification = ?updated_certification;
      get_certificate_store = ?get_certificate_store;
    };
  };

  func ensure_block_types(icrc3Class: ICRC3.ICRC3) : () {
    let supportedBlocks = Buffer.fromIter<ICRC3.BlockType>(icrc3Class.supported_block_types().vals());

    let blockequal = func(a : {block_type: Text}, b : {block_type: Text}) : Bool {
      a.block_type == b.block_type;
    };

    if(Buffer.indexOf<ICRC3.BlockType>({block_type = "1xfer"; url="";}, supportedBlocks, blockequal) == null){
      supportedBlocks.add({
            block_type = "1xfer"; 
            url="https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3";
          });
    };

    if(Buffer.indexOf<ICRC3.BlockType>({block_type = "2xfer"; url="";}, supportedBlocks, blockequal) == null){
      supportedBlocks.add({
            block_type = "2xfer"; 
            url="https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3";
          });
    };

    if(Buffer.indexOf<ICRC3.BlockType>({block_type = "2approve";url="";}, supportedBlocks, blockequal) == null){
      supportedBlocks.add({
            block_type = "2approve"; 
            url="https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3";
          });
    };

    if(Buffer.indexOf<ICRC3.BlockType>({block_type = "1mint";url="";}, supportedBlocks, blockequal) == null){
      supportedBlocks.add({
            block_type = "1mint"; 
            url="https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3";
          });
    };

    if(Buffer.indexOf<ICRC3.BlockType>({block_type = "1burn";url="";}, supportedBlocks, blockequal) == null){
      supportedBlocks.add({
            block_type = "1burn"; 
            url="https://github.com/dfinity/ICRC-1/tree/main/standards/ICRC-3";
          });
    };

    icrc3Class.update_supported_blocks(Buffer.toArray(supportedBlocks));
  };

  func icrc3() : ICRC3.ICRC3 {
    switch(_icrc3){
      case(null){
        let initclass : ICRC3.ICRC3 = ICRC3.ICRC3(?icrc3_migration_state, Principal.fromActor(this), get_icrc3_environment());
        _icrc3 := ?initclass;
        ensure_block_types(initclass);

        initclass;
      };
      case(?val) val;
    };
  };

  private func updated_certification(cert: Blob, lastIndex: Nat) : Bool{

    // D.print("updating the certification " # debug_show(CertifiedData.getCertificate(), ct.treeHash()));
    ct.setCertifiedData();
    // D.print("did the certification " # debug_show(CertifiedData.getCertificate()));
    return true;
  };

  private func get_certificate_store() : CertTree.Store {
    // D.print("returning cert store " # debug_show(cert_store));
    return cert_store;
  };

  /// Functions for the ICRC1 token standard
  public shared query func icrc1_name() : async Text {
      icrc1().name();
  };

  public shared query func icrc1_symbol() : async Text {
      icrc1().symbol();
  };

  public shared query func icrc1_decimals() : async Nat8 {
      icrc1().decimals();
  };

  public shared query func icrc1_fee() : async ICRC1.Balance {
      icrc1().fee();
  };

  public shared query func icrc1_metadata() : async [ICRC1.MetaDatum] {
      icrc1().metadata()
  };

  public shared query func icrc1_total_supply() : async ICRC1.Balance {
      icrc1().total_supply();
  };

  public shared query func icrc1_minting_account() : async ?ICRC1.Account {
      ?icrc1().minting_account();
  };

  public shared query func icrc1_balance_of(args : ICRC1.Account) : async ICRC1.Balance {
      icrc1().balance_of(args);
  };

  public shared query func icrc1_supported_standards() : async [ICRC1.SupportedStandard] {
      icrc1().supported_standards();
  };

  public shared query func icrc10_supported_standards() : async [ICRC1.SupportedStandard] {
      icrc1().supported_standards();
  };

  public shared ({ caller }) func icrc1_transfer(args : ICRC1.TransferArgs) : async ICRC1.TransferResult {
      switch(await* icrc1().transfer_tokens(caller, args, false, null)){
        case(#trappable(val)) val;
        case(#awaited(val)) val;
        case(#err(#trappable(err))) D.trap(err);
        case(#err(#awaited(err))) D.trap(err);
      };
  };

  public shared ({ caller }) func mint(args : ICRC1.Mint) : async ICRC1.TransferResult {
      if(caller != owner){ D.trap("Unauthorized")};

      switch( await* icrc1().mint_tokens(caller, args)){
        case(#trappable(val)) val;
        case(#awaited(val)) val;
        case(#err(#trappable(err))) D.trap(err);
        case(#err(#awaited(err))) D.trap(err);
      };
  };

  public shared ({ caller }) func burn(args : ICRC1.BurnArgs) : async ICRC1.TransferResult {
      switch( await*  icrc1().burn_tokens(caller, args, false)){
        case(#trappable(val)) val;
        case(#awaited(val)) val;
        case(#err(#trappable(err))) D.trap(err);
        case(#err(#awaited(err))) D.trap(err);
      };
  };

   public query ({ caller }) func icrc2_allowance(args: ICRC2.AllowanceArgs) : async ICRC2.Allowance {
      return icrc2().allowance(args.spender, args.account, false);
    };

  public shared ({ caller }) func icrc2_approve(args : ICRC2.ApproveArgs) : async ICRC2.ApproveResponse {
      switch(await*  icrc2().approve_transfers(caller, args, false, null)){
        case(#trappable(val)) val;
        case(#awaited(val)) val;
        case(#err(#trappable(err))) D.trap(err);
        case(#err(#awaited(err))) D.trap(err);
      };
  };

  public shared ({ caller }) func icrc2_transfer_from(args : ICRC2.TransferFromArgs) : async ICRC2.TransferFromResponse {
      switch(await* icrc2().transfer_tokens_from(caller, args, null)){
        case(#trappable(val)) val;
        case(#awaited(val)) val;
        case(#err(#trappable(err))) D.trap(err);
        case(#err(#awaited(err))) D.trap(err);
      };
  };

  public query func icrc3_get_blocks(args: ICRC3.GetBlocksArgs) : async ICRC3.GetBlocksResult{
    return icrc3().get_blocks(args);
  };

  public query func icrc3_get_archives(args: ICRC3.GetArchivesArgs) : async ICRC3.GetArchivesResult{
    return icrc3().get_archives(args);
  };

  public query func icrc3_get_tip_certificate() : async ?ICRC3.DataCertificate {
    return icrc3().get_tip_certificate();
  };

  public query func icrc3_supported_block_types() : async [ICRC3.BlockType] {
    return icrc3().supported_block_types();
  };

  public query func get_tip() : async ICRC3.Tip {
    return icrc3().get_tip();
  };

  public shared ({ caller }) func icrc4_transfer_batch(args: ICRC4.TransferBatchArgs) : async ICRC4.TransferBatchResults {
      switch(await* icrc4().transfer_batch_tokens(caller, args, null, null)){
        case(#trappable(val)) val;
        case(#awaited(val)) val;
        case(#err(#trappable(err))) err;
        case(#err(#awaited(err))) err;
      };
  };

  public shared query func icrc4_balance_of_batch(request : ICRC4.BalanceQueryArgs) : async ICRC4.BalanceQueryResult {
      icrc4().balance_of_batch(request);
  };

  public shared query func icrc4_maximum_update_batch_size() : async ?Nat {
      ?icrc4().get_state().ledger_info.max_transfers;
  };

  public shared query func icrc4_maximum_query_batch_size() : async ?Nat {
      ?icrc4().get_state().ledger_info.max_balances;
  };

  public shared ({ caller }) func admin_update_owner(new_owner : Principal) : async Bool {
    if(caller != owner){ D.trap("Unauthorized")};
    owner := new_owner;
    return true;
  };

  public shared ({ caller }) func admin_update_icrc1(requests : [ICRC1.UpdateLedgerInfoRequest]) : async [Bool] {
    if(caller != owner){ D.trap("Unauthorized")};
    return icrc1().update_ledger_info(requests);
  };

  public shared ({ caller }) func admin_update_icrc2(requests : [ICRC2.UpdateLedgerInfoRequest]) : async [Bool] {
    if(caller != owner){ D.trap("Unauthorized")};
    return icrc2().update_ledger_info(requests);
  };

  public shared ({ caller }) func admin_update_icrc4(requests : [ICRC4.UpdateLedgerInfoRequest]) : async [Bool] {
    if(caller != owner){ D.trap("Unauthorized")};
    return icrc4().update_ledger_info(requests);
  };

  /* /// Uncomment this code to establish have icrc1 notify you when a transaction has occured.
  private func transfer_listener(trx: ICRC1.Transaction, trxid: Nat) : () {

  };

  /// Uncomment this code to establish have icrc1 notify you when a transaction has occured.
  private func approval_listener(trx: ICRC2.TokenApprovalNotification, trxid: Nat) : () {

  };

  /// Uncomment this code to establish have icrc1 notify you when a transaction has occured.
  private func transfer_from_listener(trx: ICRC2.TransferFromNotification, trxid: Nat) : () {

  }; */

  private stable var _init = false;
  public shared(msg) func admin_init() : async () {
    //can only be called once


    if(_init == false){
      //ensure metadata has been registered
      let test1 = icrc1().metadata();
      let test2 = icrc2().metadata();
      let test4 = icrc4().metadata();
      let test3 = icrc3().stats();

      //uncomment the following line to register the transfer_listener
      //icrc1().register_token_transferred_listener<system>("my_namespace", transfer_listener);

      //uncomment the following line to register the transfer_listener
      //icrc2().register_token_approved_listener<system>("my_namespace", approval_listener);

      //uncomment the following line to register the transfer_listener
      //icrc2().register_transfer_from_listener<system>("my_namespace", transfer_from_listener);
    };
    _init := true;
  };


  // Deposit cycles into this canister.
  public shared func deposit_cycles() : async () {
      let amount = ExperimentalCycles.available();
      let accepted = ExperimentalCycles.accept<system>(amount);
      assert (accepted == amount);
  };

  system func postupgrade() {
    //re wire up the listener after upgrade
    //uncomment the following line to register the transfer_listener
      //icrc1().register_token_transferred_listener("my_namespace", transfer_listener);

      //uncomment the following line to register the transfer_listener
      //icrc2().register_token_approved_listener("my_namespace", approval_listener);

      //uncomment the following line to register the transfer_listener
      //icrc2().register_transfer_from_listener("my_namespace", transfer_from_listener);
  };

};
