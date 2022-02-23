import { LightningElement, track, wire } from "lwc";
import getContacts from "@salesforce/apex/ContactService.getContacts";
import getNumberOfRecords from "@salesforce/apex/ContactService.getNumberOfRecords";
import ACCOUNTS_CONTACTS_CHANNEL from "@salesforce/messageChannel/Accounts_Contacts__c";
import { ShowToastEvent } from "lightning/platformShowToastEvent";
import { subscribe, MessageContext } from "lightning/messageService";

const RECORDSPERPAGE = 20;
const COLUMNS = [
    { label: "First Name", fieldName: "FirstName" },
    { label: "Last Name", fieldName: "LastName" },
    { label: "Email", fieldName: "Email", type: "email" }
];

export default class AccountsView extends LightningElement {
    @track accountsSelected;
    @track contacts;
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
            this.getTotalPages();
            this.contacts = data;
        } else if (error) {
            this.contacts = undefined;
            this.showError(
                "Error when extracting contacts",
                error.body.message
            );
            console.error(error);
        }
    }

    getTotalPages() {
        getNumberOfRecords({ accounts: this.accountsSelected })
            .then((result) => {
                this.totalPages = this.calculateTotalPages(result);
                this.page =
                    this.page > this.totalPages ? this.totalPages : this.page;
            })
            .catch((error) => {
                this.totalPages = undefined;
                this.showError(
                    "Error when extracting total pages",
                    error.body.message
                );
            });
    }

    @wire(MessageContext)
    messageContext;

    // On init
    connectedCallback() {
        this.subscribeMessageChannel();
    }

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

    // Pagination
    calculateTotalPages(numberOfRecords) {
        let totalPages = Math.ceil(
            numberOfRecords / parseInt(this.recordsPerPage, 10)
        );

        // Minimun page is 1
        if (totalPages === 0) {
            totalPages = 1;
        }

        return totalPages;
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

    // Toast
    showError(title, message) {
        const evt = new ShowToastEvent({
            title: title,
            message: message,
            variant: "error"
        });
        this.dispatchEvent(evt);
    }
}
