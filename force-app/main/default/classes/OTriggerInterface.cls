public interface OTriggerInterface {
	void beforeinsert();
    void beforeupdate();
    void afterinsert();
    void afterupdate();
    void afterdelete();
    void afterundelete();
}