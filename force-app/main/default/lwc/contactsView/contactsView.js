import { LightningElement, track, wire } from "lwc";
import getContacts from "@salesforce/apex/ContactService.getContacts";
import getNumberOfRecords from "@salesforce/apex/ContactService.getNumberOfRecords";
import ACCOUNTS_CONTACTS_CHANNEL from "@salesforce/messageChannel/Accounts_Contacts__c";
import { subscribe, MessageContext } from "lightning/messageService";

const RECORDSPERPAGE = 20;
const COLUMNS = [
    { label: "First Name", fieldName: "FirstName" },
    { label: "Last Name", fieldName: "LastName" },
    { label: "Email", fieldName: "Email", type: "email" }
];

export default class AccountsView extends LightningElement {
    @track accountsSelected;
    @track data;
    @track page = 1;
    @track totalPages = 1;
    subscription = null;
    recordsPerPage = RECORDSPERPAGE;
    columns = COLUMNS;

    @wire(getContacts, {
        accounts: "$accountsSelected",
        recordsPerPage: "$recordsPerPage",
        page: "$page"
    })
    wiredContacts({ error, data }) {
        if (data) {
            this.data = data;
        } else if (error) {
            this.data = undefined;
            this.showError("Error when extracting accounts", error);
            console.error(error);
        }
    }

    @wire(getNumberOfRecords, {
        accounts: "$accountsSelected"
    })
    wiredTotalPages({ error, data }) {
        if (data) {
            this.totalPages = this.calculateTotalPages(data);
        } else if (error) {
            this.totalPages = undefined;
            this.showError("Error when extracting total pages", error);
        }
    }

    @wire(MessageContext)
    messageContext;

    // Communication between components (LMS)
    subscribeMessageChannel() {
        this.subscription = subscribe(
            this.messageContext,
            ACCOUNTS_CONTACTS_CHANNEL,
            (message) => this.handleMessage(message)
        );
    }

    handleMessage(message) {
        this.accountsSelected = message;
    }

    connectedCallback() {
        this.subscribeMessageChannel();
    }

    // Pagination
    calculateTotalPages(numberOfRecords) {
        return Math.ceil(numberOfRecords / parseInt(this.recordsPerPage, 10));
    }

    previousPage() {
        if (this.page > 1) {
            this.page--;
        }
    }

    nextPage() {
        if (this.page < this.totalPages) {
            this.page++;
        }
    }
}
